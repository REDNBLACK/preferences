#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Node, NPM and Yum integrations                                #
# ====================================================================================== #
# Depends on:  .zshrc                                                                    #
# Global vars: PATH; NPM_CONFIG_USERCONFIG                                               #
# ====================================================================================== #

# Homedir for config
declare -gx NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/node/npmrc"

# Mirror to user config
if [[ ! -f "$NPM_CONFIG_USERCONFIG" ]]; then
  ln -fs $DOTPREFSDIR/node/npmrc "$NPM_CONFIG_USERCONFIG"
fi

# Mirror to global config
if [[ ! -f "/usr/local/etc/npmrc" ]]; then
  ln -fs $DOTPREFSDIR/node/npmrc /usr/local/etc/npmrc
fi
