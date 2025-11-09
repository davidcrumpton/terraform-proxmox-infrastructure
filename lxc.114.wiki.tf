# proxmox_lxc.wiki:
resource "proxmox_lxc" "wiki" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 1
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # Wiki for CrumptonOrg
        
        https://wiki.crumpton.org
        
        ## Runs
        
        * nginx
        * wikijs
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "wiki"
    # id                   = "pve02/lxc/114"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 1024
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
    tags                 = "sso;wiki"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 114

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "16G"
        storage   = ""
        # volume    = "local-lvm:vm-114-disk-0"
    }

    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "22:25:64:1b:81:ab"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true    
    }
}
