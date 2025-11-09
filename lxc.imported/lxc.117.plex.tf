# proxmox_lxc.plex:
resource "proxmox_lxc" "plex" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 4
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # Plex Media Server
        
        Has 4TB drive as mount point for storage which is nearly full and could fill up if recording too many TV shows.
        
        https://plex.crumpton.org:32400
        
        This is open to the Internet.
        
        # Hardware
        
        * /dev/dri/card1
        * /dev/dri/renderD128
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "plex"
    # id                   = "pve02/lxc/117"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 928
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
    swap                 = 512
    tags                 = "media;public"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 117

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "80G"
        storage   = "local-lvm"
        # volume    = "local-lvm:vm-117-disk-0"
    }

    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "22:25:64:14:fa:0a"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }
}
