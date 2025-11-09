terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.9.8"
    }
  }
}

resource "proxmox_lxc" "simple_lxc" {
  target_node = var.node
  vmid        = var.vmid
  hostname    = var.hostname
  cores       = var.cores
  memory      = var.memory
  swap        = var.swap
  ostemplate = var.ostemplate
  ssh_public_keys = var.ssh_public_keys
  password = var.default_password
  start = var.start_after_creation
  onboot      = var.start_on_boot


  ostype      = "debian"
  unprivileged = true
  tags        = "poc"
  
  features     {
    nesting = true
  }

  rootfs {
    storage = var.rootfs_storage
    size    = var.rootfs_size
  }


  network {
    name      = "eth0"
    bridge    = var.bridge
    #hwaddr    = "C6:96:DC:8D:45:19"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }



  # Uncomment below if using UID/GID mapping method
  # lxc_conf {
  #   key   = "lxc.hook.autodev"
  #   value = "/usr/share/lxc/config/common.conf.d/gpu-hook"
  # }
}
