resource "proxmox_lxc" "opensearch" {
  target_node = var.node
  vmid        = 510
  hostname    = "opensearch-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_debian_12.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.opensearch_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
    # OpenSearch Elastic and Dashboard

    Collecs information from ZenArmor

    Dashboard https://opensearch.crumpton.org:5601

    elastic   https://opensearch.crumpton.org:9200

  EOT

  ostype      = var.ostemplate_debian_12.ostype
  unprivileged = true
 
  tags        = "tf-mng;monitoring;${var.ostemplate_debian_12.ostype};${var.ostemplate_debian_12.tag}"
  
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

resource "random_password" "opensearch_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "opensearch_root_password" {
  description = "Root password for the opensearch LXC container"
  value       = random_password.opensearch_root_password.result
  sensitive   = true
}