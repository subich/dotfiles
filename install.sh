#!/bin/sh
#
# Bootstrap chezmoi dotfiles.
#
# Local usage:  sh install.sh
# Remote usage: sh -c "$(curl -fsSL https://raw.githubusercontent.com/subich/dotfiles/main/install.sh)"

set -e

CHEZMOI_BIN_DIR="$HOME/.local/bin"
CHEZMOI_GITHUB_USER="subich"
CHEZMOI_INSTALL_URL="https://git.io/chezmoi"

# Print an error message to stderr and exit.
die() {
  echo "Error: $*" >&2
  exit 1
}

# Download and install chezmoi into CHEZMOI_BIN_DIR.
install_chezmoi() {
  if command -v curl > /dev/null 2>&1; then
    installer="$(curl -fsSL "$CHEZMOI_INSTALL_URL")" || die "Failed to download chezmoi installer."
  elif command -v wget > /dev/null 2>&1; then
    installer="$(wget -qO- "$CHEZMOI_INSTALL_URL")" || die "Failed to download chezmoi installer."
  else
    die "curl or wget is required to install chezmoi."
  fi
  sh -c "$installer" -- -b "$CHEZMOI_BIN_DIR"
}

# Return the chezmoi binary path, installing it first if necessary.
find_or_install_chezmoi() {
  if command -v chezmoi > /dev/null 2>&1; then
    echo "chezmoi"
  else
    install_chezmoi
    echo "$CHEZMOI_BIN_DIR/chezmoi"
  fi
}

# Apply dotfiles, detecting whether we were invoked locally or via remote pipe.
apply_dotfiles() {
  chezmoi="$(find_or_install_chezmoi)"

  if [ -f "$0" ]; then
    # Local invocation: resolve the script's directory and use it as the source.
    # POSIX-portable directory resolution: https://stackoverflow.com/a/29834779/12156188
    script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
    exec "$chezmoi" init --apply "--source=$script_dir"
  else
    # Remote invocation (piped via curl/wget): pull from the GitHub repository.
    exec "$chezmoi" init --apply "$CHEZMOI_GITHUB_USER" --keep-going
  fi
}

apply_dotfiles
