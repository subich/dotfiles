# Dotfiles

Contents:

- [.zshrc](#ZSH)
- [.tmux.conf](#tmux)
- [.vimrc](#vim)

## ZSH

LINK: [.zshrc](https://github.com/subich/dotfiles/blob/master/.zshrc)

Preferred zsh settings, completion settings, and aliases.

Install the required additional packages (with homebrew):

```shell
brew install zsh-syntax-highlighting pyenv thefuck bat prettyping ncdu fortune
```

## tmux

LINK: [.tmux.conf](https://github.com/subich/dotfiles/blob/master/.tmux.conf)

Mostly visual changes, some keybind changes for easier navigation and improvements for minor annoyances.

## vim

LINK: [.vimrc](https://github.com/subich/dotfiles/blob/master/.vimrc)

Plugins are managed by [Vundle](https://github.com/VundleVim/Vundle.vim). Download Vundle with the below command, then install plugins in `vim` with `:PluginInstall`.

```shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
