resource "proxmox_lxc" "atom5g" {
  target_node = var.node
  vmid        = 506
  hostname    = "atom5g-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_ubuntu_2204.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.atom5g_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
    # atom5g

    Print Server CUPS for 5g Network Users

  EOT

  ostype      = var.ostemplate_ubuntu_2204.ostype
  unprivileged = true
 
  tags        = "tf-mng;cups;printserver;${var.ostemplate_ubuntu_2204.ostype};${var.ostemplate_ubuntu_2204.tag}"
  
  features     {
    nesting = true
  }

  rootfs {
    storage = var.storage_pool.local
    size    = "8G"
  }


  network {
    name      = "eth0"
    bridge    = var.bridge.wifi_5g
  # hwaddr    = "C6:96:DC:8D:4C:39"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }

  network {
    name      = "eth1"
    bridge    = var.bridge.lan
  # hwaddr    = "C6:96:DC:8D:4C:39"
    type      = "veth"
    firewall  = true
    ip        = "192.168.1.247/24"
  }
}

resource "random_password" "atom5g_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "atom5g_root_password" {
  description = "Root password for the atom5g LXC container"
  value       = random_password.atom5g_root_password.result
  sensitive   = true
}

locals {
  ansible_vars_atom5g = {
    tags_list = sort(split(";", resource.proxmox_lxc.atom5g.tags))
    docker = false
    ldap_login = false
  }
}
#------------------------------------------------------------------------------
# Module-generated Ansible vars file
#------------------------------------------------------------------------------
resource "local_file" "ansible_vars_atom5g" {
  count = var.create_ansible_vars_yaml  == 1 ? 1 : 0

  content  = templatefile("${path.module}/templates/ansible_vars.yaml.tpl", local.ansible_vars_atom5g)
  filename = "${path.cwd}/ansible-vars/${resource.proxmox_lxc.atom5g.hostname}.ansible_vars.yaml"
 
  lifecycle {
    ignore_changes = [content, filename]
  }
}