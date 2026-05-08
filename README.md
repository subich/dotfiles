# dotfiles

Personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).

## What's included

| Path | Description |
| --- | --- |
| `~/.zshrc`, `~/.zprofile`, `~/.oh-my-zsh/custom/` | Zsh config (oh-my-zsh, aliases, functions) |
| `~/.gitconfig`, `~/.config/git/ignore` | Git config (templated) |
| `~/.config/nvim/` | Neovim config |
| `~/.config/lazygit/` | Lazygit config |
| `~/.config/starship.toml` | Starship prompt |
| `~/.config/delta/` | Delta diff themes |
| `~/.tmux.conf` | Tmux config |
| `~/.vimrc` | Vim config |
| `~/.psqlrc` | psql config |
| `~/.Brewfile` | Homebrew bundle (templated) |
| `~/Library/Application Support/com.mitchellh.ghostty/config` | Ghostty config |

## Prerequisites

- `curl` or `wget` (used by `install.sh` to bootstrap chezmoi if needed)

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
