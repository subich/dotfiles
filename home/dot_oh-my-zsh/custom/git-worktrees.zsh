# Manage isolated Git worktrees for parallel and agentic development.
#
#   wt <branch> [base]        Create/reopen a worktree and enter it.
#   wt                        Fuzzy-select and enter an existing worktree.
#   wt agent <branch> [base]  Enter a worktree and start the configured agent.
#   wt remove                 Remove this clean worktree; keep its branch.
#   wt done                   Remove this clean, merged worktree and branch.
#   wt list                   List worktrees.
#   wt prune                  Prune stale Git worktree metadata.
#
# Set GIT_WORKTREE_AGENT_COMMAND to override the default "kiro-cli chat".
function wt() {
  emulate -L zsh
  setopt local_options no_unset pipe_fail

  local branch="${1:-}"
  local base="${2:-HEAD}"
  local primary repo_name worktree_home worktree_path

  if [[ "$branch" == "help" || "$branch" == "-h" || "$branch" == "--help" ]]; then
    print -r -- 'usage:
  wt <branch> [base]        create/reopen a worktree and enter it
  wt                        fuzzy-select and enter a worktree
  wt agent <branch> [base]  enter a worktree and start the configured agent
  wt remove                 remove this clean worktree; keep its branch
  wt done                   remove this clean, merged worktree and branch
  wt list                   list worktrees
  wt prune                  prune stale worktree metadata

environment:
  GIT_WORKTREE_AGENT_COMMAND  agent command (default: kiro-cli chat)'
    return 0
  fi

  if [[ "$branch" == "agent" || "$branch" == "a" ]]; then
    local agent_branch="${2:-}"
    local agent_base="${3:-HEAD}"
    local agent_command="${GIT_WORKTREE_AGENT_COMMAND-kiro-cli chat}"
    local -a agent_argv
    agent_argv=("${(z)agent_command}")

    if [[ -z "$agent_branch" ]]; then
      print -u2 "usage: wt agent <branch> [base]"
      return 2
    fi
    if (( ${#agent_argv} == 0 )); then
      print -u2 "wt: GIT_WORKTREE_AGENT_COMMAND cannot be empty"
      return 2
    fi
    if ! command -v "${agent_argv[1]}" >/dev/null 2>&1; then
      print -u2 "wt: agent command '${agent_argv[1]}' is not installed"
      return 1
    fi
    wt "$agent_branch" "$agent_base" || return 1
    "${agent_argv[@]}"
    return $?
  fi

  if [[ "$branch" == "prune" ]]; then
    git worktree prune --verbose
    return $?
  fi

  if [[ "$branch" == "list" || "$branch" == "ls" ]]; then
    git worktree list --porcelain 2>/dev/null | awk '
      /^worktree / { path = substr($0, 10); branch = "(detached)" }
      /^branch / {
        branch = substr($0, 8)
        sub(/^refs\/heads\//, "", branch)
      }
      /^$/ { printf "%s\t%s\n", branch, path; path = "" }
      END { if (path != "") printf "%s\t%s\n", branch, path }
    '
    return ${pipestatus[1]}
  fi

  if [[ -z "$branch" ]]; then
    local selection selected_path
    if ! command -v fzf >/dev/null 2>&1; then
      print -u2 "wt: fzf is required for interactive worktree selection"
      return 1
    fi
    selection="$(wt list | fzf --prompt='Worktree: ' --height=~10)" || return $?
    [[ -n "$selection" ]] || return 1
    selected_path="${selection#*$'\t'}"
    cd "$selected_path"
    return $?
  fi

  primary="$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / { sub(/^worktree /, ""); print; exit }')" || return 1
  if [[ -z "$primary" ]]; then
    print -u2 "wt: not inside a Git repository"
    return 1
  fi

  if [[ "$branch" == "remove" || "$branch" == "rm" ]]; then
    local current removed_branch
    current="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
    removed_branch="$(git -C "$current" branch --show-current)" || return 1

    if [[ "$current" == "$primary" ]]; then
      print -u2 "wt: the primary worktree cannot be removed"
      return 1
    fi
    if [[ -n "$(git -C "$current" status --porcelain)" ]]; then
      print -u2 "wt: worktree has uncommitted changes; commit or stash them first"
      return 1
    fi

    cd "$primary" || return 1
    git worktree remove "$current" || return 1
    print "Removed worktree '${removed_branch:-detached}'; its branch was retained."
    return 0
  fi

  if [[ "$branch" == "done" ]]; then
    local current completed_branch
    current="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
    completed_branch="$(git -C "$current" branch --show-current)" || return 1

    if [[ "$current" == "$primary" ]]; then
      print -u2 "wt: the primary worktree cannot be completed"
      return 1
    fi
    if [[ -z "$completed_branch" ]]; then
      print -u2 "wt: cannot complete a detached worktree"
      return 1
    fi
    if [[ -n "$(git -C "$current" status --porcelain)" ]]; then
      print -u2 "wt: worktree has uncommitted changes; commit or stash them first"
      return 1
    fi
    if ! git -C "$primary" merge-base --is-ancestor "$completed_branch" HEAD; then
      print -u2 "wt: '$completed_branch' is not merged into the primary worktree"
      return 1
    fi

    cd "$primary" || return 1
    git worktree remove "$current" || return 1
    git branch -d "$completed_branch" || return 1
    print "Removed completed worktree '$completed_branch'."
    return 0
  fi

  if ! git check-ref-format --branch "$branch" >/dev/null 2>&1; then
    print -u2 "wt: invalid branch name '$branch'"
    return 2
  fi

  local existing_worktree
  existing_worktree="$(git worktree list --porcelain | awk -v target="refs/heads/${branch}" '
    /^worktree / { path = substr($0, 10) }
    /^branch / && substr($0, 8) == target { print path; exit }
  ')" || return 1
  if [[ -n "$existing_worktree" ]]; then
    cd "$existing_worktree"
    return $?
  fi

  repo_name="${primary:t}"
  worktree_home="${GIT_WORKTREE_HOME:-${HOME}/.local/share/git-worktrees}"
  worktree_path="${worktree_home}/${repo_name}/${branch}"

  if [[ ! -d "$worktree_path" ]]; then
    mkdir -p "${worktree_path:h}" || return 1
    if git show-ref --verify --quiet "refs/heads/${branch}"; then
      git worktree add "$worktree_path" "$branch" || return 1
    elif git show-ref --verify --quiet "refs/remotes/origin/${branch}"; then
      git worktree add --track -b "$branch" "$worktree_path" "origin/${branch}" || return 1
    else
      git worktree add -b "$branch" "$worktree_path" "$base" || return 1
    fi
  fi

  cd "$worktree_path"
}
