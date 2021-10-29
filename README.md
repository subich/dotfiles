# Dotfiles

Contents:

- [.zshrc](#ZSH)
- [.vimrc](#vim)
- [.tmux.conf](#tmux)

## ZSH

LINK: [.zshrc](.zshrc)

Preferred zsh settings, completion settings, and aliases. Uses Oh-my-zsh.

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

Plugins are managed by [Vundle](https://github.com/VundleVim/Vundle.vim). Download Vundle with the below command, then install plugins in `vim` with `:PluginInstall`.

```shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

## tmux

LINK: [.tmux.conf](.tmux.conf)

Mostly visual changes, some keybind changes for easier navigation and improvements for minor annoyances.
