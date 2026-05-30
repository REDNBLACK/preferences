#!/bin/sh
cmd=/usr/local/bin/transmission-remote
auth="user:pass"

trackers="${TR_TORRENT_DIR}/trackers_all.txt"
if [ ! -f $trackers ]; then
  curl -k -s https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt | awk 'NF' > "${trackers}"
fi

for tracker in $(cat $trackers); do
  args+=("-td ${tracker}")
done

${cmd} -n ${auth} -t $TR_TORRENT_ID ${args[@]}
