#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Node, NPM and Yum integrations                                #
# ====================================================================================== #
# Depends on:  .zshrc                                                                    #
# Global vars:                                                                           #
#   PATH; NPM_CONFIG_GLOBALCONFIG; NODE_REPL_HISTORY;                                    #
#   N_PREFIX; N_CACHE_PREFIX;                                                            #
# ====================================================================================== #
# n pkg manager dirs
declare -gx N_PREFIX="$XDG_CONFIG_HOME/n" # SYS #
declare -gx N_CACHE_PREFIX="$XDG_CACHE_HOME/node" # SYS #
[[ ! -d $N_CACHE_PREFIX ]] && mkdir -p "$N_CACHE_PREFIX/n/versions"

# Homedir for config
declare -gx NPM_CONFIG_GLOBALCONFIG="$DOTPREFSDIR/node/npmrc" # SYS #

# REPL history file
declare -gx NODE_REPL_HISTORY="$N_CACHE_PREFIX/.repl_history" # SYS #

# Append to PATH
if [[ -d "$N_PREFIX/bin" ]]; then
  path+=("$N_PREFIX/bin")
  declare -aU path
fi
