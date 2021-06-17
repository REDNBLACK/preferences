#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Sublime Text integrations                                     #
# ====================================================================================== #

# Create symlink if not set or broken
if [[ ! -L /usr/local/bin/subl || ! -e /usr/local/bin/subl ]]; then
  ln -fs "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi

# Set as default editor
if [ -e /usr/local/bin/subl ]; then
  typeset -gx EDITOR='subl -w'
fi
