#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Sublime Text integrations                                     #
# ====================================================================================== #
# Depends on .zshrc                                                                      #
# ====================================================================================== #
if ! internal app-installed 'Sublime Text'; then
  return 0
fi

() {
  local bin='/usr/local/bin/subl'
  local pkg=~/Library/Application\ Support/Sublime\ Text/Installed\ Packages/Package\ Control.sublime-package

  # Create symlink if not set or broken
  if [[ ! -L $bin || ! -e $bin ]]; then
    ln -fs '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' $bin
  fi

  # Set as default editor
  if [[ -e $bin ]]; then
    declare -gx EDITOR='subl -w'
  fi

  # Install PackageControl
  if [[ ! -e $pkg ]]; then
    internal download 'https://packagecontrol.io/Package Control.sublime-package' $pkg 'SublimeText'
  fi
}
