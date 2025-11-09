# proxmox_lxc.sso:
resource "proxmox_lxc" "sso" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 1
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # SSO CrumptonOrg
        
        Provides KeyCloak SSO for the Crumpton.Org realm.
        
        https://sso.crumpton.org
        
        ## Runs
        
        * nginx
        * keycloak
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "sso"
    # id                   = "pve02/lxc/113"
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
    swap                 = 512
    tags                 = "auth;important;sso"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 113

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "8G"
        storage   = "local-lvm"
        # volume    = "local-lvm:vm-113-disk-0"
    }

    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "BC:24:11:99:2C:D3"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }
}
