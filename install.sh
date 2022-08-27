#!/usr/bin/env bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
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

# Install casks
brew install --cask << CASKS
1password
alfred
bartender
docker
istat-menus
CASKS
