# SPDX-License-Identifier: MIT
module "lxc_wikijs" {
  source = "./modules/lxc"

  node        = var.target_node
  vmid        = 514
  hostname    = "wiki-js"
  cores       = var.lxc_sizing.small.cores
  memory      = var.lxc_sizing.small.memory
  swap        = var.lxc_sizing.small.swap
  ostemplate  = var.ostemplate_ubuntu_2204.template
  storage_pool = var.storage_pool.local
  root_password = random_password.wikijs_root.result
  ssh_public_keys = var.default_ssh_keys
  # features_keyctl = true
  # unprivileged = false
  description = <<-EOT
# wikijs for CrumptonOrg

https://wiki-js.crumpton.org

## Runs

* nginx
* wikijs
* nodejs
EOT

  tags = [
    "terraformed",
    "wikijs",
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

resource random_password "wikijs_root" {
  length          = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
}

resource random_password "wikijs_db" {
  length          = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
}

resource random_password "wikijs_admin" {
  length          = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
}

# This is the map of secrets we want to encrypt for the wiki-js LXC
locals {
  wikijs_secrets = {
    wikijs_db_password    = random_password.wikijs_db.result
    wikijs_admin_password = random_password.wikijs_admin.result
    # Add more secrets here, and the system handles it automatically
  }
}

data "external" "encrypted_vault" {
  program = ["${path.module}/scripts/encrypt.sh"]

  query = local.wikijs_secrets
}


output "wikijs_root_password" {
  description = "Root password for the wikijs container"
  value       = random_password.wikijs_root.result
  sensitive   = true
}

output "wikijs_db_password" {
  description = "Database password for the wikijs container"
  value       = random_password.wikijs_db.result
  sensitive   = true
}

output "wikijs_admin_password" {
  description = "WikiJS Admin Password"
  value = random_password.wikijs_admin
  sensitive = true
}
