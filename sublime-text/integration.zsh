#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Sublime Text integrations                                     #
# ====================================================================================== #
# Depends on:  .zshrc                                                                    #
# Global vars: EDITOR                                                                    #
# ====================================================================================== #
if ! internal app-installed 'Sublime Text'; then
  return 0
fi

() {
  local bin="$([[ $ARCH == 'arm64' ]] && echo '/opt/homebrew' || echo '/usr/local')/bin/subl"
  local pkg=~/Library/Application\ Support/Sublime\ Text/Installed\ Packages/Package\ Control.sublime-package

  # Set as default editor
  if [[ -e $bin ]]; then
    declare -gx EDITOR='subl -w' # SYS #
  fi

  # Install PackageControl
  if [[ ! -e $pkg ]]; then
    internal download 'https://packagecontrol.io/Package Control.sublime-package' $pkg 'SublimeText'
  fi
}
