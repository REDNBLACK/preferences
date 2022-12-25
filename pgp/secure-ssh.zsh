#!/bin/zsh
emulate -LR zsh

() {
  local ssh_cfg=/etc/ssh/ssh_config
  local sshd_cfg=/etc/ssh/sshd_config
  local store="$XDG_CONFIG_HOME/ssh"

  sudo sed -i '' -n -e '/^[# ]*UserKnownHostsFile .*$/!p' -e '$a\'$'\n'"    UserKnownHostsFile $store/known_hosts" $ssh_cfg
  for id in (id_rsa id_dsa id_ecdsa id_ed25519); do
    sudo sed -i '' -n -e '/^[# ]*IdentityFile .*'$id'$/!p' -e '$a\'$'\n'"    IdentityFile $store/$id" $ssh_cfg
    echo $id
  done

  sudo sed -i '' -n -e '/^[# ]*AuthorizedKeysFile .*$/!p' -e '$a\'$'\n'"AuthorizedKeysFile $store/authorized_keys" $sshd_cfg

  # Fix permissions
  chmod 700 "$store" && chmod 600 "$store/id_rsa" && chmod 644 "$store/id_rsa.pub" && chmod 644 "$store/known_hosts"
}
