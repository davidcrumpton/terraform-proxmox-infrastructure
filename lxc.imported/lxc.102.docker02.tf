# proxmox_lxc.docker02:
resource "proxmox_lxc" "docker02" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 2
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # Docker image storage
        
        https://docker02.crumpton.org:5000
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "docker02"
    # id                   = "pve02/lxc/102"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 896
    nameserver           = null
    onboot               = true
    password             = var.default_password
    ssh_public_keys      = var.default_ssh_keys
    ostemplate           = var.ostemplate_debian.debian_12
    ostype               = var.ostemplate_debian.ostype
    protection           = false
    restore              = false
    searchdomain         = null
    startup              = null
    swap                 = 2048
    tags                 = "docker"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 102

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "64G"
        storage   = ""
        # volume    = "local-lvm:vm-102-disk-0"
    }
    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "AE:81:3E:D9:38:22"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"  
    }
    features     {
        nesting = true
    }
}
