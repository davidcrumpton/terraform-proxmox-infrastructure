# locals {
#   vm_name          = "awesome-vm"
#   pve_node         = var.node
#   # current_node         = "pve02"
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
#     - bear
#   ssh_authorized_keys:
#     - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL8YquRYjxB123uSqoeLyjFmtnj5pi9x+mV2eb/Jvlr/oLarNX2/alC5VjpRRtqh+INmOhofgqlW479MClvrvNoFoz8vLcuL0Ppwc3+svBNODGEA5E1rQg+JU4rq8Z0ptDWQjxMN/KQ8g+sp2icA90f+HyONy8jw6vaB1ZR65qtTiVwiKavoXJwehvikeVS5Exh1rgU56yOoMxzeUto0xqCleC1Exlig5oO0Hon6L0fWSWRD6jWgu2ZvjgzKZ3GZwJJxhwIaz2xOXMDat+gx0/msnlGqSHE3onMmRixnlRb4ToGWNB3925eGKVZq6RIbQHtXYvyWWCKBEARMIche/HvRkDAvnSFKkXI9nPEuzSHXL0FEfAhzT6nIv8wYetK3FJGJnQ6hmWRMGn/jnYldp7sLzYUK50e60tufa4I+y7334Z8xN6MZJ3yhMAGKTjaWkcFfTu+vnBf9VTJFZhu0XnrCmCU5UHPn16+S7GYdlmHWWCKfq2vyDScOaPPPzAs+/L5+ysI+OqhS/JoorYvdvljPG6SNCobxJrXeFZxRUCOBkUJFiWrHRwxNXRtwchNWv0WI6rwyGHiJoLSr2453DYx8ZnlUlaBv2kaycTxg9iyH33tZXTWYtTMN5loghMVqB0o3TgLmbgtN/dKtDPVgzdYdVSX/Zru0ElOfm3b3Hayw== cardno:000604146669
#     - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHAB5iOtvm4nIHgFwYXpHr1tgm0jS8Mqjx54j/cG7W64LEVwF5mxBRyATZ7fVquoV9SGZuPDclwUmAsrj72Fyq2/YCOMpfpEB+dUYfbKA6/xp+WvJiE6K+JblCLIdF1LhsZqtzMq1UmrrAuiWhaR9ksaZOPYoeaAJS9MBHasVHiWnf6wbTEeuWuTxxXMHg86Cfy8sGzria+lHWWzTxAwiLgXGNkmQ39aUnqqWHzgBnRui9QDq6iFVK3ExjjChyBDENPCM/oRlNuGytALLI+JazKDLVPVJZOTouW/uZlyYnLyj24Bzu3XVA+ClcqStAJ0R9R7ZV/dae53rJoiyo49jp openpgp:0xA2E070F6
#   EOT

#   network_config = yamlencode({
#     version = 1
#     config = [{
#       type = "physical"
#       name = "eth0"
#       subnets = [{
#         type            = "static"
#         address         = "192.168.1.63/24"
#         gateway         = "192.168.1.1"
#         dns_nameservers = [
#           "192.168.1.1", 
#           "8.8.8.8"
#           ]
#       }]
#     }]
#   })
# }



# resource "proxmox_vm_qemu" "ubuntu2404_ci" {
#   name        = "ubuntu2404-ci"
#   target_node = var.target_node
#   vmid        = 301
#   memory      = var.vm_sizing.medium.memory
#   cpu { cores = var.vm_sizing.medium.cores }

#   depends_on = [ proxmox_cloud_init_disk.ci ]

#   # Boot CD-ROM first for installation
#   boot = "order=ide2;scsi0"

#   description          = <<-EOT
#       # Ubuntu VM Testing Cloud Init ISO Launch
#       Created with Terraform and Proxmox Provider

#       ## Access
#       SSH Access is up to the installtion user
#   EOT

#   # Networking
#   network {
#     id       = 0
#     model    = "virtio"
#     bridge   = var.bridge.lan
#     firewall = false
#   }

#   # Disks
#   disks {
#     ide {
#       ide2 {
#         cdrom {
#           iso = var.vm_iso.ubuntu_2404
#         }
#       }
#     }

#     scsi {
#       scsi0 {
#         disk {
#           size    = var.vm_sizing.medium.disk
#           storage = var.storage_pool.local
#         }
#       }
#       scsi2 {
#         cdrom {
#           iso = "${proxmox_cloud_init_disk.ci.id}"
#         }
#       }

#     }
#   }
#   tags = "cloud-init;ubuntu;testing;${var.common_tags.vm};terraform"
# }
