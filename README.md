# Dotfiles

Contents:

- [.zshrc](#ZSH)
- [.vimrc](#vim)
- [.tmux.conf](#tmux)

## ZSH

LINK: [.zshrc](.zshrc)

Preferred zsh settings, completion settings, and aliases.
Uses Oh-my-zsh.

Install oh-my-zsh:
```shell
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the below packages with your preferred package manager:
```shell
pyenv bat prettyping ncdu
```

## vim

LINK: [.vimrc](.vimrc)

Plugins are managed by [vim-plug](https://github.com/junegunn/vim-plug).
Vim-plug is auto-installed if it does not exist.
Plugins are auto-installed on first start; any plugin additions can be installed with `:PlugInstall`.
Plugins can be updated with `:PlugUpdate`, and vim-plugin can update itself with `:PlugUpgrade`.

```shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

## tmux

LINK: [.tmux.conf](.tmux.conf)

Mostly visual changes; some keybind changes for navigation improvements and minor annoyances.
