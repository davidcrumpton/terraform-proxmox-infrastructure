# proxmox_lxc.gl-runner-01:
resource "proxmox_lxc" "gl-runner-01" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 1
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # gl-runner-01
        
        Runs GitLab jobs with Docker support
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "gl-runner-01"
    # id                   = "pve02/lxc/107"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 1024
    nameserver           = null
    onboot               = true
    ostype               = "debian"
    protection           = false
    restore              = false
    searchdomain         = null
    startup              = null
    swap                 = 2048
    tags                 = "git"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 107

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "96G"
        storage   = ""
        # volume    = "local-lvm:vm-107-disk-0"
    }
}
