# proxmox_lxc.atom5g:
resource "proxmox_lxc" "atom5g" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 2
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # atom5g
        
        Print Server CUPS for 5g Network Users
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "atom5g"
    # id                   = "pve02/lxc/106"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 512
    nameserver           = null
    onboot               = true
    ostype               = "ubuntu"
    protection           = true
    restore              = false
    searchdomain         = null
    startup              = "order=10"
    swap                 = 4096
    tags                 = "cups;printserver"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 106

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "32G"
        storage   = ""
        # volume    = "local-lvm:vm-106-disk-0"
    }
}
