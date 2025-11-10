resource "proxmox_lxc" "plex" {
  target_node = var.node
  vmid        = 517
  hostname    = "plex-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_ubuntu_2204.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.plex_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
    # Plex Media Server

    Has 4TB drive as mount point for storage which is nearly full and could fill up if recording too many TV shows.

    https://plex.crumpton.org:32400

    This is open to the Internet.

    # Hardware

    * /dev/dri/card1
    * /dev/dri/renderD128

    # Mounts

    Mounts the 4G directory media as /media

Mounts the 4G media share
  EOT

  ostype      = var.ostemplate_ubuntu_2204.ostype
  unprivileged = true
 
  tags        = "tf-mng;media;public;plex;${var.ostemplate_ubuntu_2204.ostype};${var.ostemplate_ubuntu_2204.tag}"
  
  features     {
    nesting = true
  }

  rootfs {
    storage = var.storage_pool.local
    size    = "8G"
  }


  network {
    name      = "eth0"
    bridge    = var.bridge.lan
  #  hwaddr    = "C6:96:DC:8D:4C:39"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }

}

resource "random_password" "plex_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "plex_root_password" {
  description = "Root password for the plex LXC container"
  value       = random_password.plex_root_password.result
  sensitive   = true
}