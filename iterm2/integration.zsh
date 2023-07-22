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
  ## Helpers ##
  .resolve_ip() {
    resolve() {
      local ip="$(dig +tries=1 +short $1 $2 myip.opendns.com @resolver1.opendns.com 2> /dev/null)"
      case $ip in
        (';'*) echo '' ;;
        (*)    echo $ip;;
      esac
    }

    local ip=$(resolve -4 A)
    [[ -z $ip ]]                 && ip="$(resolve -6 AAAA)"
    [[ $ip =~ '^[0-9a-f.:]+$' ]] || ip='n/a'
    echo $ip
  }

  .is_vpn() {
    if [ -n "$(scutil --nc list 2> /dev/null | grep Connected)" ]; then
      return 0
    fi
    return 1
  }
  #############

  local label="$(.resolve_ip)"
  if .is_vpn; then
    label+=' '
  fi
  echo $label
}
# ============================================ #


# ============================================ #
# Set var asynchronously                       #
# ============================================ #
# Depends on iterm2_set_user_var               #
# Args:                                        #
#   1. Scope - 'Global' or 'Session'           #
#   2. iTerm Var Name                          #
#   3. Function or closure name to call        #
# ============================================ #
async_start_worker user_ctx_worker -n
async_start_worker user_public_ip_worker -n

ctx_worker_completed() {
  iterm2_set_user_var Context "$3"
}
async_register_callback user_ctx_worker ctx_worker_completed

public_ip_worker_completed() {
  iterm2_set_user_var PublicIP "$3"
  async_job user_public_ip_worker "sleep 10 && user_public_ip"
}
async_register_callback user_public_ip_worker public_ip_worker_completed

# ========================================== #
# Update on each command call                #
# ========================================== #
function iterm2_print_user_vars() {
  async_job user_ctx_worker user_context
}

# ========================================================= #
# Update every '$tick' sec with delay '$init' in background #
# ========================================================= #
async_job user_public_ip_worker user_public_ip
# ====================================================================================== #
