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
declare -gx N_PREFIX="$(brew --prefix)" # SYS #
declare -gx N_CACHE_PREFIX="$XDG_CACHE_HOME/node" # SYS #
[[ ! -d $N_CACHE_PREFIX ]] && mkdir -p "$N_CACHE_PREFIX/n/versions"

# bun dirs
declare -gx DO_NOT_TRACK="1" # SYS #
declare -gx BUN_INSTALL="$XDG_CACHE_HOME/node/bun" # SYS #
declare -gx BUN_INSTALL_CACHE_DIR="$BUN_INSTALL/cache" # SYS #
declare -gx BUN_INSTALL_GLOBAL_DIR="$BUN_INSTALL/install" # SYS #
declare -gx BUN_INSTALL_GLOBAL_STORE="1" # SYS #
declare -gx BUN_INSTALL_BIN="$N_PREFIX/bin" # SYS #

# Homedir for config
declare -gx NPM_CONFIG_GLOBALCONFIG="$DOTPREFSDIR/node/npmrc" # SYS #

# REPL history file
declare -gx NODE_REPL_HISTORY="$N_CACHE_PREFIX/.repl_history" # SYS #