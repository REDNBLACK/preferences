#!/bin/zsh
emulate -LR zsh

echo "Setting Sublime Text file associations..."

if !command -v jq &> /dev/null; then
  abort "jq is required for the script"
else
  arr_values=()
  utis=($(jq -r '.x_file_assoc | del(.[] | nulls) | to_entries | unique_by(.value) | .[].value' $DOTPREFSDIR/sublime-text3/conf/Preferences.sublime-settings))
  extensions=($(jq -r '.x_file_assoc | del(.[] | values) | to_entries | .[].key' $DOTPREFSDIR/sublime-text3/conf/Preferences.sublime-settings))

  for uti in "${utis[@]}"; do
    arr_values+=("'{LSHandlerContentType=$uti;LSHandlerRoleAll=com.sublimetext.3;}'")
  done
  unset uti

  for ext in "${extensions[@]}"; do
    arr_values+=("'{LSHandlerContentTag=$ext;LSHandlerContentTagClass=public.filename-extension;LSHandlerRoleAll=com.sublimetext.3;}'")
  done
  unset ext

  cmd='defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add'
  eval $cmd ${(j: :)arr_values}

  /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -v -apps u
fi
