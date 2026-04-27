#!/bin/sh

# Install chezmoi dotfiles - supports both local and remote invocation
# Local usage: sh install.sh
# Remote usage: sh -c "$(curl -fsSL https://raw.githubusercontent.com/subich/dotfiles/main/install.sh)"

set -e # -e: exit on error

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

# Detect invocation method: local file vs remote pipe
if [ -f "$0" ]; then
  # Local invocation: derive source dir from script location
  # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
  script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
  exec "$chezmoi" init --apply "--source=$script_dir"
else
  # Remote invocation: use repository reference
  exec "$chezmoi" init --apply subich --keep-going
fi
