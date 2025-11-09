resource "proxmox_lxc" "debian" {
  target_node = var.node
  vmid        = 201
  hostname    = "debian"
  cores       = 2
  memory      = 512
  swap        = 512
  ostemplate = var.ostemplate_debian_12.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.ns1_root_password.result
  start = true
  onboot      = true


  ostype      = var.ostemplate_debian_12.ostype
  unprivileged = true
  tags        = "poc"
  
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
    hwaddr    = "C6:96:DC:8D:4C:37"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }

}

resource "random_password" "debian_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 