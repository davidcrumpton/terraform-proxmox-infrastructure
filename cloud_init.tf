# locals {
#   vm_name          = "awesome-vm"
#   pve_node         = "pve02"
#   iso_storage_pool = "local"
# }

# resource "proxmox_cloud_init_disk" "ci" {
#   name      = local.vm_name
#   pve_node  = local.pve_node
#   storage   = local.iso_storage_pool

#   meta_data = yamlencode({
#     instance_id    = sha1(local.vm_name)
#     local-hostname = local.vm_name
#   })

#   user_data = <<-EOT
#   #cloud-config
#   users:
#     - default
#   ssh_authorized_keys:
#     - ssh-rsa AAAAB3N......
#   EOT

#   network_config = yamlencode({
#     version = 1
#     config = [{
#       type = "physical"
#       name = "eth0"
#       subnets = [{
#         type            = "static"
#         address         = "192.168.1.100/24"
#         gateway         = "192.168.1.1"
#         dns_nameservers = [
#           "1.1.1.1", 
#           "8.8.8.8"
#           ]
#       }]
#     }]
#   })
# }
# resource "proxmox_lxc" "vm_with_cloud_init" {
#   hostname     = local.vm_name
#   target_node  = local.pve_node
#   ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
#   password     = "SecurePassword123!"
#   unprivileged = true

#   rootfs {
#     storage = "local-lvm"
#     size    = "16G"
#   }

# #   cpu {
# #     cores = 2
# #   }

#   memory = 2048
#   swap   = 512

#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "dhcp"
#   }

# #   cloud_init_disk_id = proxmox_cloud_init_disk.ci.id
# }