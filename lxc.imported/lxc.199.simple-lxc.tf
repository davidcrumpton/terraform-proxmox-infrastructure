# proxmox_lxc.simple-lxc:
resource "proxmox_lxc" "simple-lxc" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = "tty"
    console              = true
    cores                = 4
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = null
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "simple-lxc"
    # id                   = "pve02/lxc/199"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 928
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
    swap                 = 512
    tags                 = "poc"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 199

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "8G"
        storage   = "local-lvm"
        # volume    = "local-lvm:vm-199-disk-0"
    }
    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "C6:96:DC:8D:45:19"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }

}
