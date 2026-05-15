#!/bin/sh
# Configure the chezmoi source repo to always commit with personal identity,
# overriding any work-profile global gitconfig on this machine.
set -e

git -C "$CHEZMOI_SOURCE_DIR" config --local user.email "20615740+subich@users.noreply.github.com"
git -C "$CHEZMOI_SOURCE_DIR" config --local user.signingkey "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjNDexSnXsX9ecW+nNyJos6skCc3HzsMlQqwrC9075m"
git -C "$CHEZMOI_SOURCE_DIR" config --local commit.gpgsign true
