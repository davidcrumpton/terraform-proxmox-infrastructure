#!/usr/bin/env bash
#set -eo pipefail
# Login to node and cd /etc/pve/lxc
# Run
#     grep hostname * | sort -u | cut -d: -f1,3
# Paste output into the while read loop below
# cp /tmp/lxc.*.tf ~/Workspace/<your terraform repo>/
# Edit each .tf file to replace hardcoded values with variables as needed
# I commented out the following values:
        #  current_node         = "pve02"
        # id                   = "pve02/lxc/102"
        # unused               = []
        # volume    = "local-lvm:vm-102-disk-0"
# I fixed the following values to use variables:
        # password             = var.default_password
        # ssh_public_keys      = var.default_ssh_keys
        # ostemplate           = var.ostemplate_ubuntu.ubuntu_22_04
        # ostype               = var.ostemplate_ubuntu.ostype
    # Note ubuntu is set to debian where appropriate
# Set storage   = "" instead of storage   = null if you want to use default storage. 
# You can set it local-lvm or local-zfs or whatever if you want to hardcode it
# to a particular storage.  Proxmox will assign the rest of the name.

# Lastly, it will output null dimmed and escaped to make it pretty
# You must search and replace these to just null due to invalid terraform syntax
# Then run this script to import into terraform state

NODE=${1:-pve02}
echo "Importing LXC containers into Terraform state..."

while read ID_BLOCK HOSTNAME_BLOCK; do
  ID=$(echo "$ID_BLOCK" | cut -d':' -f1 | cut -d'.' -f1)
  HOSTNAME=$(echo "$HOSTNAME_BLOCK" | cut -d':' -f2 | tr -d ' ')
  echo "terraform import proxmox_lxc.$HOSTNAME ${NODE}/lxc/$ID"
# show state after import
set -x
  terraform import proxmox_lxc.$HOSTNAME ${NODE}/lxc/$ID
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

