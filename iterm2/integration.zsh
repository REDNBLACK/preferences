#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          iTerm integrations                                            #
# ====================================================================================== #
# Depends on .zshrc                                                                      #
# ====================================================================================== #
if ! internal app-installed 'iTerm'; then
  return 0
fi

# ====================================================================================== #
#                          Shell & Utils integration                                     #
# ====================================================================================== #
zinit ice depth'1' atload'!PATH+=:`pwd`/utilities' pick'shell_integration/zsh'
zinit $ZINIT[LOAD_MODE] gnachman/iTerm2-shell-integration
# ====================================================================================== #


# ====================================================================================== #
#                          StatusBar integration                                         #
# ====================================================================================== #
setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR

# ============================================ #
# Helpers                                      #
# ============================================ #
user_context() {
  ## Helpers ##
  .is_ssh() {
    if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
      return 0
    elif [[ "$(ps h -o comm -p "$PPID")" =~ "sshd" ]]; then
      return 0
    else
      return 1
    fi
  }

  .is_root() {
    if [[ $EUID -eq 0 ]]; then
      return 0
    else
      return 1
    fi
  }
  #############

  local label
  if .is_ssh; then
    label=' '
  fi
  if .is_root; then
    label=" $label"
  fi
  if [[ ! -z $label ]]; then
    label="$label${(%):-%n}@$(hostname -s)"
  fi
  echo $label
}

user_public_ip() {
  local uid="$EUID"; [[ $uid -eq 0 ]] && uid="$SUDO_UID"
  local label="$(launchctl asuser $uid launchctl getenv OSX_PUBLIC_IP)"
  if [[ "$(launchctl asuser $uid launchctl getenv OSX_IS_VPN)" = "true" ]]; then
    label+=' '
  fi
  echo $label
}
# ============================================ #


# ========================================== #
# Update on each command call                #
# ========================================== #
function iterm2_print_user_vars() {
  iterm2_set_user_var Context "$(user_context)"
  # iterm2_set_user_var PublicIP "$(user_public_ip)" FIXME
}
# ====================================================================================== #
