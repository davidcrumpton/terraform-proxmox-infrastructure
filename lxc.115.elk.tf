# proxmox_lxc.elk:
resource "proxmox_lxc" "elk" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 4
    cpulimit             = 0
    cpuunits             = 1024
    # current_node         = "pve02"
    description          = <<-EOT
        # elk
        
        Runs Elasticsearch and Kibana
        
        dashboard https://elk.crumpton.org:5601
        
        elastic   https://elk.crumpton.org:9200
        
        This system collects logs either thru remote syslog or beats.
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "elk"
    # id                   = "pve02/lxc/115"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 12320
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
    swap                 = 2048
    tags                 = "monitoring"
    template             = false
    tty                  = 2
    unique               = false
    unprivileged         = true
    # unused               = []
    vmid                 = 115

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "256G"
        storage   = ""
        # volume    = "local-lvm:vm-115-disk-0"
    }
}
