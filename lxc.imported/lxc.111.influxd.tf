# proxmox_lxc.influxd:
resource "proxmox_lxc" "influxd" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 2
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # Influx Database
        
        Collects Influx Information in V2 Format
        
        https://influxd.crumpton.org:8086
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "influxd"
    # id                   = "pve02/lxc/111"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 768
    nameserver           = null
    onboot               = true
    password             = var.default_password
    ssh_public_keys      = var.default_ssh_keys
    ostemplate           = var.ostemplate_ubuntu.ubuntu_22_04
    ostype               = var.ostemplate_ubuntu.ostype
    protection           = false
    restore              = false
    searchdomain         = null
    startup              = null
    swap                 = 2048
    tags                 = "monitoring;public"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 111

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "256G"
        storage   = ""
        # volume    = "local-lvm:vm-111-disk-0"
    }
    network {
        name      = "eth0"
        bridge    = var.bridge.lan
        hwaddr    = "BC:24:11:37:AA:17"
        type      = "veth"
        firewall  = true
        ip        = "dhcp"
        ip6       = "dhcp"
    }
    features     {
        nesting = true
    }
}
