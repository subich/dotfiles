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
| `~/.config/ghostty/config` | Ghostty config |
| `~/.tmux.conf` | Tmux config |
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
| `gpg_signingkey` | GPG key ID used for commit signing in `~/.gitconfig` |

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

## Updating

```sh
chezmoi update
```

## macOS automation

These scripts run automatically on `chezmoi apply` (macOS only, re-run only when their content changes):

| Script | What it does |
| --- | --- |
| `run_onchange_install_packages` | Installs Homebrew if missing, then runs `brew bundle --global` |
| `run_onchange_after_configure-defaults` | Applies macOS `defaults` for Finder, Dock, and text replacement |
| `run_onchange_after_configure-dock` | Removes stock Apple apps from the Dock using `dockutil` |
