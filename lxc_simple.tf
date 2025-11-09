# resource "proxmox_lxc" "simple_lxc" {
#   target_node = var.node
#   vmid        = 199
#   hostname    = "simple-lxc"
#   cores       = var.lxc_sizing.small.cores
#   memory      = var.lxc_sizing.small.memory
#   swap        = var.lxc_sizing.small.swap
#   ostemplate = var.ostemplate_ubuntu_2204.template
#   ssh_public_keys = var.default_ssh_keys
#   password = random_password.simple_root_password.result
#   start = true
#   onboot      = true

#   description          = <<-EOT
#       # Simple LXC Container
#       Created with Terraform and Proxmox Provider

#       ## Access
#       SSH Access with provided SSH keys.
#       ## Root Password
#       Root password is generated and can be found in Terraform outputs.
#   EOT

#   ostype      = var.ostemplate_ubuntu_2204.ostype
#   unprivileged = true
#   tags        = "poc;${var.common_tags.lxc};${var.ostemplate_ubuntu_2204.ostype};ubuntu2204"
  
#   features     {
#     nesting = true
#   }

#   rootfs {
#     storage = var.storage_pool.local
#     size    = "8G"
#   }


#   network {
#     name      = "eth0"
#     bridge    = var.bridge.lan
#     hwaddr    = "C6:96:DC:8D:4C:39"
#     type      = "veth"
#     firewall  = true
#     ip        = "dhcp"
#     ip6       = "dhcp"
#   }

# }

# resource "random_password" "simple_root_password" {
#   length           = 24
#   override_special = "!@#$%&*()-_=+[]{}<>:?"
#   special          = true
# } 