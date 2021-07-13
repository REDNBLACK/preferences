#!/bin/zsh
emulate -LR zsh

setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR

# ====================================================================================== #
#                          iTerm integrations and tools                                  #
#                                                                                        #
# - Shell integration                                                                    #
# - Native utilities                                                                     #
# - StatusBar integration                                                                #
# ====================================================================================== #
typeset -gA ITERM_CFG=(
  [url]="https://iterm2.com"
  [git]="https://github.com/gnachman/iTerm2-shell-integration.git"
  [dir]="$XDG_CONFIG_HOME/iterm2/AppSupport"
)

# ====================================================================================== #
#                                  Shell integration install                             #
# ====================================================================================== #
() {
  local shell_file="${ITERM_CFG[dir]}/shell-integration.zsh"

  if [[ ! -e $shell_file ]]; then
    print_info "[iTerm] Downloading shell integration..."
    curl -SsL -o $shell_file "${ITERM_CFG[url]}/shell_integration/zsh"
  fi

  . $shell_file
}
# ====================================================================================== #


# ====================================================================================== #
#                                  Utils installation                                    #
# ====================================================================================== #
() {
  local utils_dir="${ITERM_CFG[dir]}/Utils"

  if [[ ! -d $utils_dir ]]; then
    print_info "[iTerm] Cloning utils..."
    git clone -q --depth 1 $ITERM_CFG[git] integration
    mke $utils_dir && mv integration/utilities/* $_ && rm -rf integration
    chmod a+x $utils_dir/*
  fi

  path+=("$utils_dir")
}
# ====================================================================================== #


# ====================================================================================== #
#                                  StatusBar integration                                 #
# ====================================================================================== #
. $DOTPREFSDIR/iterm2/statusbar.plugin.zsh

# ========================================== #
# Update on each command call                #
# ========================================== #
function iterm2_print_user_vars() {
  iterm2_set_user_var_async Local Context "iterm2_user_context"
}

# ========================================================= #
# Update every '$tick' sec with delay '$init' in background #
# ========================================================= #
function iterm2_update_user_vars_job() {
  typeset -i init=$1
  typeset -i tick=$2

  sleep $init
  while :; do
    iterm2_set_user_var_async Global PublicIP "iterm2_user_public_ip"
    sleep $tick
  done
}
() { iterm2_update_user_vars_job 1 10 & }
# ====================================================================================== #
