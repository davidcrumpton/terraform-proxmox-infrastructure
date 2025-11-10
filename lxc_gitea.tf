resource "proxmox_lxc" "gitea" {
  target_node = var.node
  vmid        = 509
  hostname    = "gitea-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_ubuntu_2204.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.gitea_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
    # Nextcloud

    https://suite.eaglecreek.work

  EOT

  ostype      = var.ostemplate_ubuntu_2204.ostype
  unprivileged = true
 
  tags        = "tf-mng;git;${var.ostemplate_ubuntu_2204.tag};${var.ostemplate_ubuntu_2204.ostype}"
  
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

resource "random_password" "gitea_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "gitea_root_password" {
  description = "Root password for the gitea LXC container"
  value       = random_password.gitea_root_password.result
  sensitive   = true
}