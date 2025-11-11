resource "proxmox_lxc" "gl_runner" {
  target_node = var.node
  vmid        = 507
  hostname    = "gitlab-runnder-01-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_debian_12.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.gl_runner_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
    # gl_runner

    Print Server CUPS for 5g Network Users

  EOT

  ostype      = var.ostemplate_debian_12.ostype
  unprivileged = true
 
  tags        = "tf-mng;git;${var.ostemplate_debian_12.ostype};${var.ostemplate_debian_12.tag}"
  
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
  # hwaddr    = "C6:96:DC:8D:4C:39"
    type      = "veth"
    firewall  = true
    ip        = "dhcp"
    ip6       = "dhcp"
  }

}

resource "random_password" "gl_runner_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "gl_runner_root_password" {
  description = "Root password for the gl_runner LXC container"
  value       = random_password.gl_runner_root_password.result
  sensitive   = true
}

locals {
  ansible_vars_gl_runner = {
    tags_list = sort(split(";", resource.proxmox_lxc.simple_lxc.tags))
    docker = false
    ldap_login = false
  }
}
#------------------------------------------------------------------------------
# Module-generated Ansible vars file
#------------------------------------------------------------------------------
resource "local_file" "ansible_vars_gl_runner" {
  count = var.create_ansible_vars_yaml  == 1 ? 1 : 0

  content  = templatefile("${path.module}/templates/ansible_vars.yaml.tpl", local.ansible_vars_gl_runner)
  filename = "${path.cwd}/ansible-vars/${resource.proxmox_lxc.simple_lxc.hostname}.ansible_vars.yaml"
 
  lifecycle {
    ignore_changes = [content, filename]
  }
}