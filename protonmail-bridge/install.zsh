#!/bin/zsh
emulate -LR zsh
declare -A user=([name]=`id -un` [uid]=`id -u` [home]=`echo ~`)
declare -A io=(
  [label]='com.proton.mail.bridge'
  [bin]='/usr/local/bin/bridge'
  [daemon]='/Library/LaunchDaemons/com.proton.mail.bridge.plist'
  [log]="${user[home]}/Library/Application Support/protonmail/bridge-v3/logs/bridge.log"
)

log() { echo "`date -Iseconds` $1" }

exec &>> ${io[log]}
log "Running install with: $user"

install -C -m 755 -o ${user[name]} bin/bridge ${io[bin]}
log "Installed binary: ${io[bin]}"

sudo install -C -m 644 -o root launch/com.proton.mail.bridge.plist ${io[daemon]}
sudo /usr/libexec/PlistBuddy \
  -c "Set UserName ${user[name]}" \
  -c "Set EnvironmentVariables:HOME ${user[home]}" \
  -c "Set StandardErrorPath ${io[log]}" \
  -c "Set StandardOutPath ${io[log]}" \
  ${io[daemon]} > /dev/null
log "Installed launcher: ${io[daemon]}"

log "Adding service to launchctl and then disable"
launchctl bootstrap "gui/${user[uid]}" ${io[daemon]}
launchctl disable   "gui/${user[uid]}/${io[label]}"
launchctl bootout   "gui/${user[uid]}/${io[label]}"
