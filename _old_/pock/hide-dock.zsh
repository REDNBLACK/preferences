#!/bin/zsh
emulate -LR zsh

if [[ "$1" == "apply" ]]; then
  echo "Hiding Dock..."
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 1000.0
  defaults write com.apple.dock no-bouncing -bool true
  killall Dock
elif [[ "$1" == "unapply" ]]; then
  echo "Restoring Dock..."
  defaults write com.apple.dock autohide -bool false
  defaults delete com.apple.dock autohide-delay
  killall Dock
else
  echo "Usage: hide-dock.zsh [apply|unapply]"
fi
