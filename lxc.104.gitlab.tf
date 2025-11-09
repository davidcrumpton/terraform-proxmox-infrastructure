# proxmox_lxc.gitlab:
resource "proxmox_lxc" "gitlab" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 4
    cpulimit             = 0
    cpuunits             = 1024
    current_node         = "pve02"
    description          = <<-EOT
        # GitLab Automation Server
        
        Runs GitLab via CrumptonOrg SSO
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "gitlab"
    id                   = "pve02/lxc/104"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 16384
    nameserver           = null
    onboot               = true
    ostype               = "debian"
    protection           = true
    restore              = false
    searchdomain         = null
    startup              = null
    swap                 = 2048
    tags                 = "git;sso"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    unused               = []
    vmid                 = 104

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "128G"
        storage   = null
        volume    = "local-lvm:vm-104-disk-0"
    }
}
