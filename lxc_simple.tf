resource "proxmox_lxc" "simple_lxc" {
  target_node = var.node
  vmid        = 199
  hostname    = "simple-lxc"
  cores       = 2
  memory      = 512
  swap        = 2048
  ostemplate = var.ostemplate_ubuntu_2204.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.simple_root_password.result
  start = true
  onboot      = true


  ostype      = var.ostemplate_ubuntu_2204.ostype
  unprivileged = true
  tags        = "poc"
  
  features     {
    nesting = true
  }

  rootfs {
    storage = var.storage_pool
    size    = "8G"
  }


  network {
    name      = "eth0"
    bridge    = var.bridge.lan
    hwaddr    = "C6:96:DC:8D:4C:39"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }

}

resource "random_password" "simple_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 