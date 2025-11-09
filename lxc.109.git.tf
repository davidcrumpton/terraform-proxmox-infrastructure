# proxmox_lxc.git:
resource "proxmox_lxc" "git" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 2
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # Git
        
        runs GitTea at https://git.crumpton.org
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "git"
    # id                   = "pve02/lxc/109"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 768
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
    swap                 = 1024
    tags                 = "git;sso"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 109

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "64G"
        storage   = ""
        # volume    = "local-lvm:vm-109-disk-0"
    }
    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "BC:24:11:14:F3:31"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }
}
