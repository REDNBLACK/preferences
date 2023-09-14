#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Node, NPM and Yum integrations                                #
# ====================================================================================== #
# Depends on:  .zshrc                                                                    #
# Global vars:                                                                           #
# PATH; NPM_CONFIG_USERCONFIG; NODE_REPL_HISTORY; N_PREFIX; N_CACHE_PREFIX               #
# ====================================================================================== #
# n pkg manager dirs
declare -gx N_PREFIX="$XDG_CONFIG_HOME/n" # SYS #
declare -gx N_CACHE_PREFIX="$XDG_CACHE_HOME/node" # SYS #
[[ ! -d $N_CACHE_PREFIX ]] && mkdir -p "$N_CACHE_PREFIX/n/versions"

# Homedir for config
declare -gx NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/node/npmrc" # SYS #

# REPL history file
declare -gx NODE_REPL_HISTORY="$N_CACHE_PREFIX/.repl_history" # SYS #

# Mirror to user config
if [[ ! -f "$NPM_CONFIG_USERCONFIG" ]]; then
  mkdir -p "$(dirname $NPM_CONFIG_USERCONFIG)"
  ln -fs $DOTPREFSDIR/node/npmrc "$NPM_CONFIG_USERCONFIG"
fi

# Mirror to global config
if [[ ! -f "/usr/local/etc/npmrc" ]]; then
  sudo ln -fs $DOTPREFSDIR/node/npmrc /usr/local/etc/npmrc
fi

# Append to PATH
if [[ -d "$N_PREFIX/bin" ]]; then
  path+=("$N_PREFIX/bin")
  declare -aU path
fi
