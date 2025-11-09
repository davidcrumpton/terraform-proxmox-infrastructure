#!/usr/bin/env bash
#set -eo pipefail

while read ID_BLOCK HOSTNAME_BLOCK; do
  ID=$(echo "$ID_BLOCK" | cut -d':' -f1 | cut -d'.' -f1)
  HOSTNAME=$(echo "$HOSTNAME_BLOCK" | cut -d':' -f2 | tr -d ' ')
  echo "terraform import proxmox_lxc.$HOSTNAME pve02/lxc/$ID"
# show state after import
set -x
  terraform import proxmox_lxc.$HOSTNAME pve02/lxc/$ID
  terraform state show proxmox_lxc.$HOSTNAME > /tmp/lxc.$ID.$HOSTNAME.tf
set +x
done << __END__
101.conf:hostname: nextsuite
102.conf:hostname: docker02
104.conf:hostname: gitlab
106.conf:hostname: atom5g
107.conf:hostname: gl-runner-01
109.conf:hostname: git
110.conf:hostname: opensearch
111.conf:hostname: influxd
113.conf:hostname: sso
114.conf:hostname: wiki
115.conf:hostname: elk
117.conf:hostname: plex
118.conf:hostname: pve01-backup
199.conf:hostname: simple-lxc
__END__

echo "Done."

