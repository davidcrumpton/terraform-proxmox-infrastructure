# proxmox_lxc.nextsuite:
resource "proxmox_lxc" "nextsuite" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 8
    cpulimit             = 0
    cpuunits             = 1024
    current_node         = "pve02"
    description          = <<-EOT
        # Nextcloud
        
        https://suite.eaglecreek.work
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "nextsuite"
    id                   = "pve02/lxc/101"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 2048
    nameserver           = null
    onboot               = true
    ostype               = "ubuntu"
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
    unused               = []
    vmid                 = 101

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "64G"
        storage   = null
        volume    = "local-lvm:vm-101-disk-0"
    }
}
