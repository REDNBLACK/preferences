#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Node, NPM and Yum integrations                                #
# ====================================================================================== #
# Depends on:  .zshrc                                                                    #
# Global vars: PATH; NPM_CONFIG_USERCONFIG                                               #
# ====================================================================================== #

declare -gx N_CACHE_PREFIX="$XDG_CACHE_HOME/node"
[[ ! -d $N_CACHE_PREFIX ]] && mkdir -p "$N_CACHE_PREFIX/n/versions"

# Homedir for config
declare -gx NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/node/npmrc"

# REPL history file
declare -gx NODE_REPL_HISTORY="$N_CACHE_PREFIX/.repl_history"

# Mirror to user config
if [[ ! -f "$NPM_CONFIG_USERCONFIG" ]]; then
  ln -fs $DOTPREFSDIR/node/npmrc "$NPM_CONFIG_USERCONFIG"
fi

# Mirror to global config
if [[ ! -f "/usr/local/etc/npmrc" ]]; then
  sudo ln -fs $DOTPREFSDIR/node/npmrc /usr/local/etc/npmrc
fi
