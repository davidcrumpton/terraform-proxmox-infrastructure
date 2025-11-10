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