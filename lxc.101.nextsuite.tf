# proxmox_lxc.nextsuite:
resource "proxmox_lxc" "nextsuite" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 8
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # Nextcloud
        
        https://suite.eaglecreek.work
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "nextsuite"
    # id                   = "pve02/lxc/101"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 2048
    nameserver           = null
    onboot               = true
    password             = var.default_password
    ssh_public_keys      = var.default_ssh_keys
    ostemplate           = var.ostemplate_ubuntu.ubuntu_22_04
    ostype               = var.ostemplate_ubuntu.ostype

    protection           = true
    restore              = false
    searchdomain         = null
    startup              = null
    swap                 = 2048
    tags                 = "cloud;important;office;public"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 101

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "64G"
        storage   = ""
        # volume    = "local-lvm:vm-101-disk-0"
    }
    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "BC:24:11:2B:D1:ED"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }
}