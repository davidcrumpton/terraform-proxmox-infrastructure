module "lxc_git" {
  source = "./modules/lxc"

  node        = var.target_node
  vmid        = 509
  hostname    = "git"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate  = var.ostemplate_ubuntu_2204.template
  storage_pool = var.storage_pool.local
  root_password = random_password.git_root.result
  ssh_public_keys = var.default_ssh_keys
  description = <<-EOT
# Git

runs GitTea at https://git.crumpton.org

EOT

  tags = [
    "terraformed",
    "docker",
    "sso",
    "git",
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

resource random_password "git_root" {
  length          = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
}


output "git_root_password" {
  description = "Root password for the git container"
  value       = random_password.git_root.result
  sensitive   = true
}
