module "lxc_gl_runner" {
  source = "./modules/lxc"

  node        = var.node
  vmid        = 507
  hostname    = "gl-runner-01-ng"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate  = var.ostemplate_debian_12.template
  storage_pool = var.storage_pool.local
  root_password = random_password.gl_runner_root.result
  ssh_public_keys = var.default_ssh_keys
  description = <<-EOT
# gl-runner-01

Runs GitLab jobs with Docker support

EOT

  tags = [
    "tf-mng",
    "git",
    "docker",
    var.ostemplate_debian_12.ostype,
    var.ostemplate_debian_12.tag,
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
