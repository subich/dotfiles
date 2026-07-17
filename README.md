# dotfiles

Personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).

## What's included

| Path | Description |
| --- | --- |
| `~/.zshrc`, `~/.zprofile` | Zsh config (templated) |
| `~/.oh-my-zsh/` | oh-my-zsh — managed as an external archive |
| `~/.oh-my-zsh/custom/` | oh-my-zsh custom aliases and functions |
| `~/.gitconfig` | Git config (templated) |
| `~/.config/git/aliases`, `~/.config/git/ignore` | Git aliases and global ignore |
| `~/.config/nvim/` | Neovim config |
| `~/.config/lazygit/` | Lazygit config |
| `~/.config/starship.toml` | Starship prompt |
| `~/.config/delta/` | Delta diff themes |
| `~/.config/ghostty/config.ghostty` | Ghostty config |
| `~/.config/tmux/tmux.conf` | Tmux config |
| `~/.vimrc` | Vim config |
| `~/.psqlrc` | psql config |
| `~/.Brewfile` | Homebrew bundle (templated) |

## Prerequisites

- `curl` or `wget` (used by `install.sh` to bootstrap chezmoi if needed)

## Configuration

On first run, `chezmoi init` will prompt for:

| Variable | Description |
| --- | --- |
| `profile` | Environment profile — `personal` or `work` (controls Brewfile contents and zprofile path entries) |
| `email` | Used in `~/.gitconfig` |
| `gpg_signingkey` | SSH signing key (public key or 1Password key reference) used for commit signing |

## Install

**Remote install** (new machine, installs chezmoi if needed, then applies from GitHub):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/subich/dotfiles/main/install.sh)"
```

**Local install** (from a cloned copy of this repo):

```sh
cd dotfiles
./install.sh
```

## Git worktrees

The `wt` Zsh function manages isolated worktrees under
`~/.local/share/git-worktrees/<repo>/`:

```sh
wt DAT-123-short-description       # create/reopen and enter
wt agent DAT-123-short-description # enter and launch the configured agent
wt                                 # fuzzy-select an existing worktree
wt remove                          # remove worktree, retain branch
wt done                            # remove clean merged worktree and branch
wt list                            # list all worktrees
wt prune                           # remove stale worktree metadata
```

Set `GIT_WORKTREE_HOME` to override the storage root. The agent command defaults to
`kiro-cli chat`; override it for another tool, including any arguments:

```sh
export GIT_WORKTREE_AGENT_COMMAND='claude'
# or for one invocation:
GIT_WORKTREE_AGENT_COMMAND='codex --full-auto' wt agent DAT-123-description
```

`wt remove` and `wt done` refuse dirty worktrees, and `wt done` also refuses
branches not merged into the primary worktree.

## Updating

```sh
chezmoi update
```

## Terminal workflow

Ghostty is the terminal renderer and tmux owns persistent sessions, windows, and panes. The first Ghostty surface automatically attaches to the `main` tmux session; later surfaces, including the quick terminal, open a normal login shell.

Tmux uses its default `Ctrl-b` prefix. The primary workflow bindings are:

| Binding | Action |
| --- | --- |
| `Alt-h/j/k/l` | Move between panes without the prefix |
| `Alt-1` through `Alt-9` | Select a window without the prefix |
| `prefix C-d h/j/k/l` | Split in a direction |
| `prefix r h/j/k/l` | Resize repeatedly; uppercase resizes farther; `Escape` exits |
| `prefix z` | Toggle pane zoom |
| `prefix f` | Switch sessions or open a project from zoxide history |
| `prefix g` | Open lazygit in a popup |
| `prefix t` | Open a temporary shell in a popup |
| `prefix w` | Open the tmux session/window tree |
| `prefix [` | Enter vi-style copy mode (`v` selects, `y` copies) |
| `prefix R` | Reload the tmux configuration |

The project picker creates one tmux session per selected directory. Session state is saved every 15 minutes by tmux-continuum and restored through tmux-resurrect; pane scrollback is deliberately excluded. After applying the dotfiles, install newly declared TPM plugins from tmux with `prefix I`.

## macOS automation

These scripts run automatically on `chezmoi apply` (macOS only, re-run only when their content changes):

| Script | What it does |
| --- | --- |
| `run_onchange_install_packages` | Installs Homebrew if missing, then runs `brew bundle --global` |
| `run_onchange_after_configure-defaults` | Applies macOS `defaults` for Finder, Dock, and text replacement |
| `run_onchange_after_configure-dock` | Removes stock Apple apps from the Dock using `dockutil` |
