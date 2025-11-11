resource "proxmox_lxc" "debian" {
  target_node = var.node
  vmid        = 201
  hostname    = "debian"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_debian_12.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.debian_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
      # Debian Testing LXC Container
      Created with Terraform and Proxmox Provider

      ## Access
      SSH Access with provided SSH keys.
      ## Root Password
      Root password is generated and can be found in Terraform outputs.
  EOT

  ostype      = var.ostemplate_debian_12.ostype
  unprivileged = true

  tags = "poc;${var.common_tags.lxc};${var.ostemplate_debian_12.ostype};debian12"
  
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
    hwaddr    = "C6:96:DC:8D:4C:37"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }

}

resource "random_password" "debian_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "debian_root_password" {
  description = "Root password for the Debian LXC container"
  value       = random_password.debian_root_password.result
  sensitive   = true
}


locals {
  ansible_vars_debian = {
    tags_list = sort(split(";", resource.proxmox_lxc.debian.tags))
    docker = false
    ldap_login = false
  }
}
#------------------------------------------------------------------------------
# Module-generated Ansible vars file
#------------------------------------------------------------------------------
resource "local_file" "ansible_vars_debian" {
  count = var.create_ansible_vars_yaml  == 1 ? 1 : 0

  content  = templatefile("${path.module}/templates/ansible_vars.yaml.tpl", local.ansible_vars_debian)
  filename = "${path.cwd}/ansible-vars/${resource.proxmox_lxc.debian.hostname}.ansible_vars.yaml"
 
  lifecycle {
    ignore_changes = [content, filename]
  }
}