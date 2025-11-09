# proxmox_lxc.pve01-backup:
resource "proxmox_lxc" "pve01-backup" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 1
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # PVE01-Backup
        
        This system has an account to backup pve01 data via SMB.
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "pve01-backup"
    # id                   = "pve02/lxc/118"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 208
    nameserver           = null
    onboot               = true
    ostype               = "ubuntu"
    protection           = true
    restore              = false
    searchdomain         = null
    startup              = null
    swap                 = 512
    tags                 = "backup"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 118

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "420G"
        storage   = ""
        # volume    = "local-lvm:vm-118-disk-0"
    }
}
