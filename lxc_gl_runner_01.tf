module "lxc_gl_runner" {
  source = "./modules/lxc"

  node        = var.node
  vmid        = 506
  hostname    = "gl_runner_01-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate  = var.ostemplate_ubuntu_2204.template
  storage_pool = var.storage_pool.local
  root_password = random_password.gl_runner_root.result
  ssh_public_keys = var.default_ssh_keys
  description = <<-EOT
Print Server CUPS for 5G Network Users
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
      bridge = var.bridge.wifi_5g
      ip     = "dhcp"
      ip6    = "dhcp"
    },
    {
      name   = "eth1"
      bridge = var.bridge.lan
      ip     = "192.168.1.247/24"
      ip6    = "dhcp"
    }
  ]
}

resource random_password "gl_runner_root" {
  length          = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
}


output "gl_runner_root_password" {
  description = "Root password for the gl_runner container"
  value       = random_password.gl_runner_root.result
  sensitive   = true
}
