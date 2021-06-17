#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Sublime Text files association setup                          #
# ====================================================================================== #
function () {
  if !command -v jq &> /dev/null; then
    print_err "Installation of jq is required to set Sublime Text file associations"
  else
    print_info "Setting Sublime Text file associations..."

    local cfg="$DOTPREFSDIR/sublime-text/conf/Preferences.sublime-settings"
    local utis=($(jq -r '.x_file_assoc | del(.[] | nulls) | to_entries | unique_by(.value) | .[].value' $cfg))
    local exts=($(jq -r '.x_file_assoc | del(.[] | values) | to_entries | .[].key' $cfg))
    local args=()

    for u (${utis[@]}) args+=("--uti $u")
    for e (${exts[@]}) args+=("--ext $e")

    eval 'duti' ${(j: :)args} '--rebuild' 'com.sublimetext.4'
  fi
}
