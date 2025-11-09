resource "proxmox_lxc_guest" "wikijs01" {
    name         = "wikijs01"
    power_state  = "running"
    target_node         = "pve02"
    unprivileged = true

    ssh_public_keys = var.default_ssh_keys
    password     = random_password.wikijs_root_password.result
    template {
        file    = var.ostemplate_ubuntu_2204.template_lxcg
        storage = "local"
    }
    cpu {
        cores = var.lxc_sizing.small.cores
    }
    memory = var.lxc_sizing.small.memory
    swap   = var.lxc_sizing.small.swap
    pool   = "wikijs-pool"
    root_mount {
        size    = var.lxc_sizing.small.disk
        storage = "local-lvm"
    }
    # Data mount point (mp0)
    mount {
        guest_path = "/wikijs"
        slot = "mp1"
        size    = "256M"           # Size of the disk
        storage = var.storage_pool.local   # Storage pool to use (e.g., local-lvm, cephfs)
    
    }
    # Backup mount point (mp1)
    mount {
        guest_path = "/backup"
        slot = "mp0"
        size    = "256M"         
        storage = var.storage_pool.local 
        # Optional: Set a flag to exclude this disk from backups of the main VM config
        # backup  = false
    }
    network {
        id = 0
        name = "eth0"
        bridge = "vmbr0"
        ipv4_dhcp = true
        ipv6_dhcp = true
    }
    tags = [ "terraform",  "wikijs01", var.common_tags.lxcg ]
}

resource "proxmox_lxc_guest" "wikijs02" {
    name         = "wikijs02"
    power_state  = "running"
    target_node         = "pve02"
    unprivileged = true

    ssh_public_keys = var.default_ssh_keys
    password     = random_password.wikijs_root_password.result
    template {
        file    = var.ostemplate_ubuntu_2204.template_lxcg
        storage = "local"
    }
    cpu {
        cores = var.lxc_sizing.small.cores
    }
    memory = var.lxc_sizing.small.memory
    swap   = var.lxc_sizing.small.swap
    pool   = "wikijs-pool"
    root_mount {
        size    = var.lxc_sizing.small.disk
        storage = "local-lvm"
    }
    # Data mount point (mp0)
    mount {
        guest_path = "/wikijs"
        slot = "mp1"
        size    = "256M"           # Size of the disk
        storage = var.storage_pool.local   # Storage pool to use (e.g., local-lvm, cephfs)
    
    }
    # Backup mount point (mp1)
    mount {
        guest_path = "/backup"
        slot = "mp0"
        size    = "256M"         
        storage = var.storage_pool.local 
        # Optional: Set a flag to exclude this disk from backups of the main VM config
        # backup  = false
    }
    network {
        id = 0
        name = "eth0"
        bridge = "vmbr0"
        ipv4_dhcp = true
        ipv6_dhcp = true
    }
    tags = [ "terraform", "wikijs02", var.common_tags.lxcg ]
}

resource "random_password" "wikijs_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 