module "plex" {
  source = "./lxc.d/plex"
 

  vmid            = 117
  hostname        = "plex"
  cores           = 4
  memory          = 928
  swap            = 512
  rootfs_storage  = "local-lvm"
  rootfs_size     = "80G"
  media_storage   = "media"
  media_size      = "4100G"
  bridge          = "vmbr0"
}

module "gitlab_runner" {
  source = "./lxc.d/gitlab-runner"

  vmid            = 117
  hostname        = "gitlab-runner"
  cores           = 4
  memory          = 928
  swap            = 512
  rootfs_storage  = "local-lvm"
  rootfs_size     = "8G"
  bridge          = "vmbr0"
}
resource "proxmox_lxc" "basic" {
  target_node  = "pve02"
  hostname     = "lxc-basic"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password     = "BasicLXCContainer"
  unprivileged = true

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
  tags = "terraform;basic;example"
}

resource "proxmox_lxc_guest" "minimal-example" {
    name         = "minimal-example"
    power_state  = "running"
    target_node         = "pve02"
    unprivileged = true
    password     = "yourpassword"
    template {
        file    = "ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        storage = "local"
    }
    cpu {
        cores = 1
    }
    memory = 1024
    swap   = 512
    pool   = "my-pool"
    root_mount {
        size    = "4G"
        storage = "local-lvm"
    }
    network {
        id = 0
        name = "eth0"
        bridge = "vmbr0"
        ipv4_address = "192.168.1.100/24"
        ipv4_gateway = "192.168.1.1"
    }
    tags = [ "terraform", "basic", "example" ]
}

resource "proxmox_lxc" "multiple_mountpoints" {
  target_node  = "pve"
  hostname     = "lxc-multiple-mountpoints"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged = true
  ostype       = "ubuntu"

  ssh_public_keys = <<-EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL8YquRYjxB123uSqoeLyjFmtnj5pi9x+mV2eb/Jvlr/oLarNX2/alC5VjpRRtqh+INmOhofgqlW479MClvrvNoFoz8vLcuL0Ppwc3+svBNODGEA5E1rQg+JU4rq8Z0ptDWQjxMN/KQ8g+sp2icA90f+HyONy8jw6vaB1ZR65qtTiVwiKavoXJwehvikeVS5Exh1rgU56yOoMxzeUto0xqCleC1Exlig5oO0Hon6L0fWSWRD6jWgu2ZvjgzKZ3GZwJJxhwIaz2xOXMDat+gx0/msnlGqSHE3onMmRixnlRb4ToGWNB3925eGKVZq6RIbQHtXYvyWWCKBEARMIche/HvRkDAvnSFKkXI9nPEuzSHXL0FEfAhzT6nIv8wYetK3FJGJnQ6hmWRMGn/jnYldp7sLzYUK50e60tufa4I+y7334Z8xN6MZJ3yhMAGKTjaWkcFfTu+vnBf9VTJFZhu0XnrCmCU5UHPn16+S7GYdlmHWWCKfq2vyDScOaPPPzAs+/L5+ysI+OqhS/JoorYvdvljPG6SNCobxJrXeFZxRUCOBkUJFiWrHRwxNXRtwchNWv0WI6rwyGHiJoLSr2453DYx8ZnlUlaBv2kaycTxg9iyH33tZXTWYtTMN5loghMVqB0o3TgLmbgtN/dKtDPVgzdYdVSX/Zru0ElOfm3b3Hayw== cardno:000604146669
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHAB5iOtvm4nIHgFwYXpHr1tgm0jS8Mqjx54j/cG7W64LEVwF5mxBRyATZ7fVquoV9SGZuPDclwUmAsrj72Fyq2/YCOMpfpEB+dUYfbKA6/xp+WvJiE6K+JblCLIdF1LhsZqtzMq1UmrrAuiWhaR9ksaZOPYoeaAJS9MBHasVHiWnf6wbTEeuWuTxxXMHg86Cfy8sGzria+lHWWzTxAwiLgXGNkmQ39aUnqqWHzgBnRui9QDq6iFVK3ExjjChyBDENPCM/oRlNuGytALLI+JazKDLVPVJZOTouW/uZlyYnLyj24Bzu3XVA+ClcqStAJ0R9R7ZV/dae53rJoiyo49jp openpgp:0xA2E070F6
  EOT

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  // Storage Backed Mount Point
  mountpoint {
    key     = "0"
    slot    = 0
    storage = "local-lvm"
    mp      = "/mnt/container/storage-backed-mount-point"
    size    = "12G"
  }

  // Bind Mount Point
  mountpoint {
    key     = "1"
    slot    = 1
    storage = "/srv/host/bind-mount-point"
    // Without 'volume' defined, Proxmox will try to create a volume with
    // the value of 'storage' + : + 'size' (without the trailing G) - e.g.
    // "/srv/host/bind-mount-point:256".
    // This behaviour looks to be caused by a bug in the provider.
    volume  = "/srv/host/bind-mount-point"
    mp      = "/mnt/container/bind-mount-point"
    size    = "256G"
  }

  // Device Mount Point
  mountpoint {
    key     = "2"
    slot    = 2
    storage = "/dev/sdg"
    volume  = "/dev/sdg"
    mp      = "/mnt/container/device-mount-point"
    size    = "32G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
    ip6    = "dhcp"
  }
}