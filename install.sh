#!/usr/bin/env bash

function install_homebrew {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install_packages {
    brew install << PACKAGES
    bat
    diff-so-fancy
    fzf
    gh
    htop
    httpie
    irssi
    mosh
    prettyping
    python
    ranger
    speedtest-cli
    the_silver_searcher
    tmux
    vim
    zsh-syntax-highlighting
PACKAGES
}

function install_casks {
    brew install --cask << CASKS
    1password
    alfred
    bartender
    docker
    istat-menus
    iterm2
    nova
CASKS
}

function copy_configs {
    rsync \
        --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude "install.sh" \
        --exclude "README.md" \
        -avh --no-perms . $HOME
}


install_homebrew
install_packages
install_casks

copy_configs

touch $HOME/.access_tokens
vim +PlugInstall
