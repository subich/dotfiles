#!/bin/bash

set -eufo pipefail

# Key hold delay before repeat starts (default: 68; System Settings range: 15–120)
# defaults write -g InitialKeyRepeat -int 15
# Key repeat rate once repeating (default: 6; 2 = faster than System Settings minimum; System Settings range: 2–120)
# defaults write -g KeyRepeat -int 2
# Clear all text replacement shortcuts
defaults write -g NSUserDictionaryReplacementItems '()'

# Auto-hide the Dock when not in use
defaults write com.apple.dock autohide -bool true
# Position the Dock at the bottom of the screen
defaults write com.apple.dock orientation -string bottom

# Set the default view style for folders without custom setting
# (Nlsv: List view, clmv: Column view, icnv: Icon view, glyv: Gallery view)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Remove items in the bin after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
