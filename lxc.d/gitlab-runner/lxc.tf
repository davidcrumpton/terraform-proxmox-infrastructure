terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.9.8"
    }
  }
}

resource "proxmox_lxc" "gl_runner" {
  vmid        = var.vmid
  hostname    = var.hostname
  cores       = var.cores
  memory      = var.memory
  swap        = var.swap
  ostype      = "debian"
  unprivileged = true
  tags        = "git"
  onboot      = true
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
    hwaddr    = "C6:96:DC:8D:45:19"
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
