# proxmox_lxc.gitlab:
resource "proxmox_lxc" "gitlab" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 4
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # GitLab Automation Server
        
        Runs GitLab via CrumptonOrg SSO
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "gitlab"
    # id                   = "pve02/lxc/104"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 16384
    nameserver           = null
    onboot               = true
    password             = var.default_password
    ssh_public_keys      = var.default_ssh_keys
    ostemplate           = var.ostemplate_debian.debian_12
    ostype               = var.ostemplate_debian.ostype
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
    # unused               = []
    vmid                 = 104

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "128G"
        storage   = ""
        # volume    = "local-lvm:vm-104-disk-0"
    }
    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "EE:22:EE:A0:33:5E"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }
}
