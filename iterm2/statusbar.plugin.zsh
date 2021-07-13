0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
ITERM_STATUSBAR_JOBS_PATH=$XDG_CONFIG_HOME/iterm2/AppSupport/Jobs
if [[ ! -e $ITERM_STATUSBAR_JOBS_PATH ]]; then
  mkdir -p $ITERM_STATUSBAR_JOBS_PATH
fi

function __resolve_ip() {
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

function __is_vpn() {
  for line in ${(f)"$(command ifconfig 2> /dev/null)"}; do
    if [[ $line =~ ^(gpd|ipsec|wg|tailscale)[0-9]*:.*$ ]]; then
      return 0
    fi
  done
  return 1
}

function __is_ssh() {
  if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
    return 0
  else
    local me
    me="$(who -m 2> /dev/null)" || me=${(@M)${(f)"$(who 2> /dev/null)"}:#*[[:space:]]${TTY#/dev/}[[:space:]]*}

    if [[ $me =~ "\(?(([0-9]{1,3}\.){3}[0-9]+|(([0-9a-fA-F]+:)|:){2,}[0-9a-fA-F]+|([.][^. ]+){2})\)?\$" ]]; then
      return 0
    else
      return 1
    fi
  fi
}

function __is_root() {
  if [[ $EUID -eq 0 ]]; then
    return 0
  else
    return 1
  fi
}


iterm2_user_context() {
  local label
  if __is_ssh; then
    label=' '
  fi
  if __is_root; then
    label=" $label"
  fi
  if [[ ! -z $label ]]; then
    label="$label${(%):-%n}@$(hostname -s)"
  fi
  echo $label
  # sleep 10 && echo " ${(%):-%n}@$(hostname -s)"
}


iterm2_user_public_ip() {
  local label="$(__resolve_ip)"
  if __is_vpn; then
    label+=' '
  fi
  echo $label
}


# ============================================ #
# Set var asynchronously                       #
# ============================================ #
# Depends on iterm2_set_user_var               #
# Args:                                        #
#   1. Scope - 'Global' or 'Session'           #
#   2. iTerm Var Name                          #
#   3. Function or closure name to call        #
# ============================================ #
iterm2_set_user_var_async() {
  local scope=$([ $1 = 'Global' ] && echo 'Global' || echo $ITERM_SESSION_ID)
  local pipe="$ITERM_STATUSBAR_JOBS_PATH/$scope-$2.pipe"
  local pid="$(cat $pipe 2> /dev/null)"
  if [[ $pid -ne 0 ]] && ps -p $pid > /dev/null; then
    #
  else
    iterm2_set_user_var $2 "$($3)" &
    echo $! > $pipe
  fi
}
