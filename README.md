# dotfiles

Personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).

## What's included

| Path | Description |
| --- | --- |
| `~/.zshrc`, `~/.zprofile` | Zsh config (oh-my-zsh, aliases, functions) |
| `~/.gitconfig` | Git config (templated) |
| `~/.config/nvim/` | Neovim config (LazyVim) |
| `~/.config/lazygit/` | Lazygit config |
| `~/.config/starship.toml` | Starship prompt |
| `~/.config/delta/` | Delta diff themes |
| `~/.tmux.conf` | Tmux config |
| `~/.vimrc` | Vim config |
| `~/.psqlrc` | psql config |
| `~/.Brewfile` | Homebrew bundle (templated) |

## Prerequisites

- [1Password CLI](https://developer.1password.com/docs/cli/) — secrets are stored in [1Password](https://1password.com)

Sign in before applying:

```sh
eval $(op signin)
```

## Install

**On a new machine** (installs chezmoi if needed, then applies):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/subich/dotfiles/main/remote_install.sh)"
```

**If chezmoi is already installed:**

```sh
chezmoi init --apply subich
```

## Updating

```sh
chezmoi update
```
