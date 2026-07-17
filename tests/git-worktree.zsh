#!/usr/bin/env zsh

set -eu

source "${0:A:h}/../home/dot_oh-my-zsh/custom/git-worktrees.zsh"

function test_creates_and_enters_worktree() {
  local sandbox repo expected
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  expected="${sandbox}/worktrees/example/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  cd "$repo"
  GIT_WORKTREE_HOME="${sandbox}/worktrees" wt feature-one >/dev/null

  [[ "$PWD" == "$expected" ]] || {
    print -u2 "expected PWD '$expected', got '$PWD'"
    return 1
  }
  [[ "$(git branch --show-current)" == "feature-one" ]] || {
    print -u2 "expected branch 'feature-one'"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_lists_worktrees() {
  local sandbox repo output
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "${sandbox}/feature-one"

  cd "$repo"
  output="$(wt list)"
  [[ "$output" == *$'main\t'"${repo:A}"* ]] || {
    print -u2 "expected main worktree in list, got: $output"
    return 1
  }
  [[ "$output" == *$'feature-one\t'"${sandbox:A}/feature-one"* ]] || {
    print -u2 "expected feature worktree in list, got: $output"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_done_removes_clean_merged_worktree_and_branch() {
  local sandbox repo worktree
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  worktree="${sandbox}/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "$worktree"

  cd "$worktree"
  wt done >/dev/null

  [[ "$PWD" == "${repo:A}" ]] || {
    print -u2 "expected to return to primary worktree, got '$PWD'"
    return 1
  }
  [[ ! -d "$worktree" ]] || {
    print -u2 "expected completed worktree to be removed"
    return 1
  }
  ! git -C "$repo" show-ref --verify --quiet refs/heads/feature-one || {
    print -u2 "expected merged branch to be deleted"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_remove_drops_worktree_but_keeps_unmerged_branch() {
  local sandbox repo worktree
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  worktree="${sandbox}/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "$worktree"
  touch "${worktree}/feature"
  git -C "$worktree" add feature
  git -C "$worktree" commit -qm "add feature"

  cd "$worktree"
  wt remove >/dev/null

  [[ "$PWD" == "${repo:A}" ]] || {
    print -u2 "expected to return to primary worktree, got '$PWD'"
    return 1
  }
  [[ ! -d "$worktree" ]] || {
    print -u2 "expected worktree to be removed"
    return 1
  }
  git -C "$repo" show-ref --verify --quiet refs/heads/feature-one || {
    print -u2 "expected unmerged branch to be retained"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_no_args_selects_an_existing_worktree() {
  local sandbox repo worktree
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  worktree="${sandbox}/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "$worktree"

  function fzf() {
    command awk '/^feature-one\t/ { print; exit }'
  }

  cd "$repo"
  wt
  [[ "$PWD" == "${worktree:A}" ]] || {
    print -u2 "expected selected worktree '${worktree:A}', got '$PWD'"
    return 1
  }

  unfunction fzf
  cd /
  rm -rf "$sandbox"
}

function test_agent_creates_worktree_and_launches_kiro() {
  local sandbox repo expected agent_pwd=""
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  expected="${sandbox}/worktrees/example/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  function kiro-cli() {
    [[ "$1" == "chat" ]] || return 1
    agent_pwd="$PWD"
  }

  cd "$repo"
  GIT_WORKTREE_HOME="${sandbox}/worktrees" wt agent feature-one >/dev/null
  [[ "$agent_pwd" == "$expected" ]] || {
    print -u2 "expected Kiro to launch in '$expected', got '$agent_pwd'"
    return 1
  }

  unfunction kiro-cli
  cd /
  rm -rf "$sandbox"
}

function test_existing_remote_branch_is_checked_out_with_tracking() {
  local sandbox repo expected
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  expected="${sandbox}/worktrees/example/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  git -C "$repo" remote add origin /dev/null
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" switch -qc feature-one
  touch "${repo}/remote-feature"
  git -C "$repo" add remote-feature
  git -C "$repo" commit -qm "remote feature"
  git -C "$repo" update-ref refs/remotes/origin/feature-one HEAD
  git -C "$repo" switch -q main
  git -C "$repo" branch -D feature-one >/dev/null

  cd "$repo"
  GIT_WORKTREE_HOME="${sandbox}/worktrees" wt feature-one >/dev/null

  [[ -f "${expected}/remote-feature" ]] || {
    print -u2 "expected remote branch content in worktree"
    return 1
  }
  [[ "$(git rev-parse --abbrev-ref '@{upstream}')" == "origin/feature-one" ]] || {
    print -u2 "expected branch to track origin/feature-one"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_prune_removes_stale_worktree_metadata() {
  local sandbox repo worktree output
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  worktree="${sandbox}/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "$worktree"
  rm -rf "$worktree"

  cd "$repo"
  wt prune
  output="$(git worktree list --porcelain)"
  [[ "$output" != *"$worktree"* ]] || {
    print -u2 "expected stale worktree metadata to be pruned"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_branch_name_enters_worktree_created_elsewhere() {
  local sandbox repo worktree
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  worktree="${sandbox}/custom-location"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "$worktree"

  cd "$repo"
  GIT_WORKTREE_HOME="${sandbox}/worktrees" wt feature-one >/dev/null
  [[ "$PWD" == "${worktree:A}" ]] || {
    print -u2 "expected existing worktree '${worktree:A}', got '$PWD'"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_agent_command_can_be_overridden() {
  local sandbox repo expected agent_pwd="" agent_args=""
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  expected="${sandbox}/worktrees/example/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  function alternate-agent() {
    agent_pwd="$PWD"
    agent_args="$*"
  }

  cd "$repo"
  GIT_WORKTREE_HOME="${sandbox}/worktrees" \
    GIT_WORKTREE_AGENT_COMMAND='alternate-agent --mode autonomous' \
    wt agent feature-one >/dev/null
  [[ "$agent_pwd" == "$expected" ]] || {
    print -u2 "expected alternate agent to launch in '$expected', got '$agent_pwd'"
    return 1
  }
  [[ "$agent_args" == "--mode autonomous" ]] || {
    print -u2 "expected alternate agent arguments, got '$agent_args'"
    return 1
  }

  unfunction alternate-agent
  cd /
  rm -rf "$sandbox"
}

test_creates_and_enters_worktree
print "ok: creates and enters worktree"
test_lists_worktrees
print "ok: lists worktrees"
test_done_removes_clean_merged_worktree_and_branch
print "ok: removes completed worktree"
test_remove_drops_worktree_but_keeps_unmerged_branch
print "ok: removes worktree and keeps branch"
test_no_args_selects_an_existing_worktree
print "ok: selects existing worktree"
test_agent_creates_worktree_and_launches_kiro
print "ok: launches Kiro in worktree"
test_agent_command_can_be_overridden
print "ok: launches configured agent command"
test_existing_remote_branch_is_checked_out_with_tracking
print "ok: tracks existing remote branch"
test_prune_removes_stale_worktree_metadata
print "ok: prunes stale metadata"
test_branch_name_enters_worktree_created_elsewhere
print "ok: enters externally created worktree"


function test_rejects_invalid_branch_name() {
  local sandbox repo
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  cd "$repo"
  GIT_WORKTREE_HOME="${sandbox}/worktrees" wt "..invalid" 2>/dev/null && {
    print -u2 "expected invalid branch name to be rejected"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_errors_outside_git_repo() {
  local sandbox
  sandbox="$(mktemp -d)"

  cd "$sandbox"
  wt "some-branch" 2>/dev/null && {
    print -u2 "expected error outside a git repo"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_done_refuses_unmerged_branch() {
  local sandbox repo worktree
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  worktree="${sandbox}/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "$worktree"
  touch "${worktree}/unmerged-file"
  git -C "$worktree" add unmerged-file
  git -C "$worktree" commit -qm "unmerged work"

  cd "$worktree"
  wt done 2>/dev/null && {
    print -u2 "expected done to refuse unmerged branch"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_remove_refuses_dirty_worktree() {
  local sandbox repo worktree
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"
  worktree="${sandbox}/feature-one"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"
  git -C "$repo" worktree add -q -b feature-one "$worktree"
  echo "dirty" > "${worktree}/uncommitted"

  cd "$worktree"
  wt remove 2>/dev/null && {
    print -u2 "expected remove to refuse dirty worktree"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_done_refuses_primary_worktree() {
  local sandbox repo
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  cd "$repo"
  wt done 2>/dev/null && {
    print -u2 "expected done to refuse on primary worktree"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_remove_refuses_primary_worktree() {
  local sandbox repo
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  cd "$repo"
  wt remove 2>/dev/null && {
    print -u2 "expected remove to refuse on primary worktree"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_help_prints_usage() {
  local output
  output="$(wt help)"
  [[ "$output" == *"usage:"* ]] || {
    print -u2 "expected help output to contain 'usage:'"
    return 1
  }
}

function test_agent_requires_branch_arg() {
  local sandbox repo rc
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  cd "$repo"
  rc=0
  wt agent 2>/dev/null || rc=$?
  [[ $rc -eq 2 ]] || {
    print -u2 "expected exit code 2 for missing branch, got $rc"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

function test_agent_errors_when_command_not_found() {
  local sandbox repo
  sandbox="$(mktemp -d)"
  repo="${sandbox}/example"

  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Worktree Test"
  git -C "$repo" config user.email "worktree@example.com"
  git -C "$repo" config commit.gpgsign false
  touch "${repo}/README"
  git -C "$repo" add README
  git -C "$repo" commit -qm "initial commit"

  cd "$repo"
  GIT_WORKTREE_HOME="${sandbox}/worktrees" \
    GIT_WORKTREE_AGENT_COMMAND='nonexistent-agent-xyz' \
    wt agent feature-one 2>/dev/null && {
    print -u2 "expected error when agent command is not found"
    rm -rf "$sandbox"
    return 1
  }

  cd /
  rm -rf "$sandbox"
}

test_rejects_invalid_branch_name
print "ok: rejects invalid branch name"
test_errors_outside_git_repo
print "ok: errors outside git repo"
test_done_refuses_unmerged_branch
print "ok: done refuses unmerged branch"
test_remove_refuses_dirty_worktree
print "ok: remove refuses dirty worktree"
test_done_refuses_primary_worktree
print "ok: done refuses on primary worktree"
test_remove_refuses_primary_worktree
print "ok: remove refuses on primary worktree"
test_help_prints_usage
print "ok: help prints usage"
test_agent_requires_branch_arg
print "ok: agent requires branch argument"
test_agent_errors_when_command_not_found
print "ok: agent errors when command not found"
