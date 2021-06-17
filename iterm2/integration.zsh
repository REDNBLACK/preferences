#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          iTerm integrations and tools                                  #
#                                                                                        #
# - Shell integration                                                                    #
# - Various utilities                                                                    #
# ====================================================================================== #
typeset -A ITERM_CFG=(
  [url]="https://iterm2.com"
  [dir]="$XDG_CONFIG_HOME/iterm2"
)

# ====================================================================================== #
#                                  Shell integration installation                        #
# ====================================================================================== #
ITERM_CFG[integration_file]="${ITERM_CFG[dir]}/integration.zsh"

if [[ ! -e $ITERM_CFG[integration_file] ]]; then
  print_info "[iTerm] Downloading shell integration..."
  mke $ITERM_CFG[dir]
  curl -SsL "${ITERM_CFG[url]}/shell_integration/zsh" > $ITERM_CFG[integration_file]
fi

. $ITERM_CFG[integration_file]
# ====================================================================================== #


# ====================================================================================== #
#                                  Utils installation                                    #
# ====================================================================================== #
ITERM_CFG[utils_dir]="${ITERM_CFG[dir]}/utils"

if [[ ! -e $ITERM_CFG[utils_dir] ]]; then
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

  mke $ITERM_CFG[utils_dir]

  for util in ${utils[@]}; do
    print_info "[iTerm] Downloading util $util..."
    curl -SsL "${ITERM_CFG[url]}/utilities/$util" > "${ITERM_CFG[utils_dir]}/$util"
    chmod +x "${ITERM_CFG[utils_dir]}/$util"
  done
  unset utils util
fi

for util ("${ITERM_CFG[utils_dir]}"/*(:t)) alias $util="${ITERM_CFG[utils_dir]}/$util"
unset util
# ====================================================================================== #
