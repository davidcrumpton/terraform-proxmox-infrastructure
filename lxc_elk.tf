resource "proxmox_lxc" "elk" {
  target_node = var.node
  vmid        = 515
  hostname    = "elk-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_ubuntu_2204.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.elk_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
    # elk

    Runs Elasticsearch and Kibana

    dashboard https://elk.crumpton.org:5601

    elastic   https://elk.crumpton.org:9200

    This system collects logs either thru remote syslog or beats.

  EOT

  ostype      = var.ostemplate_ubuntu_2204.ostype
  unprivileged = true
 
  tags        = "tf-mng;auth;important;elk;${var.ostemplate_ubuntu_2204.ostype};${var.ostemplate_ubuntu_2204.tag}"
  
  features     {
    nesting = true
  }

  rootfs {
    storage = var.storage_pool.local
    size    = "8G"
  }


  network {
    name      = "eth0"
    bridge    = var.bridge.lan
  #  hwaddr    = "C6:96:DC:8D:4C:39"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }

}

resource "random_password" "elk_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "elk_root_password" {
  description = "Root password for the elk LXC container"
  value       = random_password.elk_root_password.result
  sensitive   = true
}