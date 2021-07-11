#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          iTerm integrations and tools                                  #
#                                                                                        #
# - Shell integration                                                                    #
# - Various utilities                                                                    #
# ====================================================================================== #
typeset -gA ITERM_CFG=(
  [url]="https://iterm2.com"
  [dir]="$XDG_CONFIG_HOME/iterm2/AppSupport"
  [update_timer]=0
  [update_should]=false
)

# ====================================================================================== #
#                                  Shell integration installation                        #
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

  if [[ ! -e $utils_dir ]]; then
    mke $utils_dir

    local utils=(
      imgcat
      imgls
      it2api
      it2attention
      it2check
      it2copy
      it2dl
      it2getvar
      it2git
      it2setcolor
      it2setkeylabel
      it2ul
      it2universion
    )

    for util in ${utils[@]}; do
      print_info "[iTerm] Downloading util $util..."
      curl -SsL -o "$utils_dir/$util" "${ITERM_CFG[url]}/utilities/$util"
      chmod a+x "$utils_dir/$util"
    done
  fi

  path+=("$utils_dir")
}
# ====================================================================================== #


# ====================================================================================== #
#                                  Custom vars integration                               #
# ====================================================================================== #
function iterm2_print_user_vars() {
  tick() {
    ITERM_CFG[update_should]=false

    local old=$ITERM_CFG[update_timer]
    local now=$(date +%s)
    if [ $old -eq 0 ] || [ $now -ge $old ]; then
      ITERM_CFG[update_timer]=$(($now + $1))
      ITERM_CFG[update_should]=true
    fi
  }

  public_ip() {
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

  is_vpn() {
    local vpn=false

    for line in ${(f)"$(command ifconfig 2> /dev/null)"}; do
      if [[ $line =~ ^(gpd|ipsec|wg|tailscale)[0-9]*:.*$ ]]; then
        vpn=true
        break
      fi
    done

    echo $vpn
  }

  is_ssh() {
    if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
      echo true
    else
      local me
      me="$(who -m 2> /dev/null)" || me=${(@M)${(f)"$(who 2> /dev/null)"}:#*[[:space:]]${TTY#/dev/}[[:space:]]*}

      if [[ $me =~ "\(?(([0-9]{1,3}\.){3}[0-9]+|(([0-9a-fA-F]+:)|:){2,}[0-9a-fA-F]+|([.][^. ]+){2})\)?\$" ]]; then
        echo true
      else
        echo false
      fi
    fi
  }

  is_root() {
    echo "$([ $EUID -eq 0 ] && echo true || echo false)"
  }

  # ======================= #
  # Update on every call    #
  # ======================= #
  local ctx
  [[ $(is_ssh) = true ]]  && ctx=" $ctx"
  [[ $(is_root) = true ]] && ctx=" $ctx"

  iterm2_set_user_var Context "$([ ! -z $ctx ] && echo "$ctx${(%):-%n}@$(hostname -s)" || echo '')"


  # ======================= #
  # Update after 10 seconds #
  # ======================= #
  tick 10
  if [ $ITERM_CFG[update_should] = true ]; then
    iterm2_set_user_var PublicIP "$(public_ip)$([ $(is_vpn) = true ] && echo ' ' || echo '')"
  fi
}
# ====================================================================================== #
