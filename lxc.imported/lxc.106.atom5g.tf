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
    password             = var.default_password
    ssh_public_keys      = var.default_ssh_keys
    ostemplate           = var.ostemplate_ubuntu.ubuntu_22_04
    ostype               = var.ostemplate_ubuntu.ostype
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

#net0: name=eth0,bridge=vmbr10,firewall=1,hwaddr=AA:A1:98:4D:41:2B,ip=dhcp,ip6=dhcp,type=veth
#net1: name=eth1,bridge=vmbr0,firewall=1,hwaddr=96:BB:CB:1C:9E:F3,ip=192.168.1.5/24,type=veth
    network {
        name      = "eth0"
        bridge    = var.bridge.wifi_5g
        hwaddr    = "AA:A1:98:4D:41:2B"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    network {
        name      = "eth1"
        bridge    = var.bridge.lan
        hwaddr    = "96:BB:CB:1C:9E:F3"
        type      = "veth"
        firewall  = true
        ip        = "192.168.1.5/24"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }   
}
