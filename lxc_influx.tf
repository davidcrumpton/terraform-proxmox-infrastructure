resource "proxmox_lxc" "influx" {
  target_node = var.node
  vmid        = 511
  hostname    = "influx-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate = var.ostemplate_ubuntu_2204.template
  ssh_public_keys = var.default_ssh_keys
  password = random_password.influx_root_password.result
  start = true
  onboot      = true

  description          = <<-EOT
    # Influx Database

    Collects Influx Information in V2 Format

    https://influxd.crumpton.org:8086


  EOT

  ostype      = var.ostemplate_ubuntu_2204.ostype
  unprivileged = true
 
  tags        = "tf-mng;monitoring;public;${var.ostemplate_ubuntu_2204.ostype};${var.ostemplate_ubuntu_2204.tag}"
  
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

resource "random_password" "influx_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 

output "influx_root_password" {
  description = "Root password for the influx LXC container"
  value       = random_password.influx_root_password.result
  sensitive   = true
}

locals {
  ansible_vars_influx = {
    tags_list = sort(split(";", resource.proxmox_lxc.simple_lxc.tags))
    docker = false
    ldap_login = false
  }
}
#------------------------------------------------------------------------------
# Module-generated Ansible vars file
#------------------------------------------------------------------------------
resource "local_file" "ansible_vars_influx" {
  count = var.create_ansible_vars_yaml  == 1 ? 1 : 0

  content  = templatefile("${path.module}/templates/ansible_vars.yaml.tpl", local.ansible_vars_influx)
  filename = "${path.cwd}/ansible-vars/${resource.proxmox_lxc.simple_lxc.hostname}.ansible_vars.yaml"
 
  lifecycle {
    ignore_changes = [content, filename]
  }
}