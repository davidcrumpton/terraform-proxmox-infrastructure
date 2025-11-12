# modules/lxc/main.tf
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=2.9.0"
    }
  }
}

resource "proxmox_lxc" "this" {
  target_node = var.node
  vmid        = var.vmid
  hostname    = var.hostname
  cores       = var.cores
  memory      = var.memory
  swap        = var.swap
  ostemplate  = var.ostemplate
  start       = true
  onboot      = true
  unprivileged = true
  ssh_public_keys = var.ssh_public_keys
  password    = var.root_password
  tags        = join(";", var.tags)

  features {
    nesting = var.features_nesting
  }

  rootfs {
    storage = var.storage_pool
    size    = var.disk_size
  }

  dynamic "network" {
    for_each = var.networks
    content {
      name     = network.value.name
      bridge   = network.value.bridge
      type     = "veth"
      firewall = true
      ip       = network.value.ip
      ip6      = network.value.ip6
    }
  }

  description = var.description
}

locals {
  ansible_vars = {
    hostname   = var.hostname
    vmid       = proxmox_lxc.this.vmid
    tags_list  = sort(split(";", proxmox_lxc.this.tags))
    ip_addrs   = [for net in proxmox_lxc.this.network : net.ip]
    macs       = [for net in proxmox_lxc.this.network : net.hwaddr]
    node       = var.node
    features   = { nesting = var.features_nesting }
    storage    = var.storage_pool
    networks   = var.networks
  }
}

# write YAML vars
resource "local_file" "ansible_vars" {
  content  = templatefile("${path.module}/templates/ansible_vars.yaml.tpl", local.ansible_vars)
  filename = "${path.root}/ansible/host_vars/${var.hostname}/main.yml"
}

output "ansible_data" {
  value = local.ansible_vars
}

resource "null_resource" "ansible_apply" {
  triggers = {
    inventory_hash = filesha1("${path.root}/ansible/inventory/hosts")
  }

  provisioner "local-exec" {
    command = "${path.root}/run_ansible.sh site.yml"
    interpreter = ["/bin/sh", "-c"]
  }
}
