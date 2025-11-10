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