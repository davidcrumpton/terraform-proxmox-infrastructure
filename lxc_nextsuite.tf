module "lxc_nextsuite" {
  source = "./modules/lxc"

  node        = var.node
  vmid        = 501
  hostname    = "nextsuite-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate  = var.ostemplate_ubuntu_2204.template
  storage_pool = var.storage_pool.local
  root_password = random_password.nextsuite_root.result
  ssh_public_keys = var.default_ssh_keys
  description = <<-EOT
# Nextcloud

https://suite.eaglecreek.work

EOT

  tags = [
    "tf-mng",
    "cups",
    "printserver",
    var.ostemplate_ubuntu_2204.ostype,
    var.ostemplate_ubuntu_2204.tag,
  ]

  networks = [
    {
      name   = "eth0"
      bridge = var.bridge.lan
      ip     = "dhcp"
      ip6    = "dhcp"
    }
  ]
}

resource random_password "nextsuite_root" {
  length          = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
}


output "nextsuite_root_password" {
  description = "Root password for the nextsuite container"
  value       = random_password.nextsuite_root.result
  sensitive   = true
}
