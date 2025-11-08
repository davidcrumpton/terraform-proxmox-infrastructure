#!/bin/bash
# generate_lxc_tf.sh
# Generates Terraform files for all existing LXCs on Proxmox
# Usage: ./generate_lxc_tf.sh

# Folder to hold generated TF files
OUTPUT_DIR="lxc.d"
mkdir -p "$OUTPUT_DIR"

# Get list of all LXCs: VMID, Name
# Format: VMID Name
pct list | tail -n +2 | awk '{print $1, $2}' | while read vmid name; do
    # Clean name for Terraform (replace - with _)
    tfname=$(echo "$name" | tr '-' '_')
    tf_file="$OUTPUT_DIR/${tfname}.tf"

    # Generate basic Terraform resource
    cat > "$tf_file" <<EOF
resource "proxmox_lxc" "$tfname" {
  vmid       = $vmid
  hostname   = "$name"
  ostype     = "ubuntu"
  unprivileged = true
  onboot     = true
  target_node = "pve02"

  # Default resources (adjust as needed)
  cores      = 2
  memory     = 512
  swap       = 512

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    type   = "veth"
    ip     = "dhcp"
    ip6    = "dhcp"
  }
}
EOF

    # Print Terraform import command
    echo "terraform import proxmox_lxc.$tfname $vmid"

done
