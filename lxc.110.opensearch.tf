# proxmox_lxc.opensearch:
resource "proxmox_lxc" "opensearch" {
    arch                 = "amd64"
    bwlimit              = 0
    cmode                = null
    console              = true
    cores                = 2
    cpulimit             = 0
    cpuunits             = 1024
    current_node         = "pve02"
    description          = <<-EOT
        # OpenSearch Elastic and Dashboard
        
        Collecs information from ZenArmor
        
        Dashboard https://opensearch.crumpton.org:5601
        
        elastic   https://opensearch.crumpton.org:9200
    EOT
    force                = false
    hagroup              = null
    hastate              = null
    hookscript           = null
    hostname             = "opensearch"
    id                   = "pve02/lxc/110"
    ignore_unpack_errors = false
    lock                 = null
    memory               = 2560
    nameserver           = null
    onboot               = true
    ostype               = "debian"
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
    unused               = []
    vmid                 = 110

    rootfs {
        acl       = false
        quota     = false
        replicate = false
        ro        = false
        shared    = false
        size      = "64G"
        storage   = null
        volume    = "local-lvm:vm-110-disk-0"
    }
}
