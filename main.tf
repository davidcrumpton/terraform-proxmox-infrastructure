terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

provider "proxmox" {
  # You can provide credentials via variables (below) or via the provider's
  # environment variables (PM_API_URL, PM_USER, PM_PASSWORD, PM_API_TOKEN_ID,
  # PM_API_TOKEN_SECRET, PM_TLS_INSECURE). The provider will use what is
  # available — prefer token-based auth for automation.

  pm_api_url       = var.pm_api_url        # e.g. "https://proxmox.example:8006/api2/json"
  pm_user          = var.pm_user           # e.g. "root@pam" or "terraform@pve"
  pm_password      = var.pm_password       # optional when using token
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure  = var.pm_tls_insecure
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