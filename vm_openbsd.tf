# resource "proxmox_vm_qemu" "openbsd76" {
#   name        = "openbsd76"
#   target_node = var.target_node
#   vmid        = 300
#   memory      = var.vm_sizing.medium.memory
#   cpu { cores = var.vm_sizing.medium.cores }

#   # Boot CD-ROM first for installation
#   boot = "order=ide2;scsi0"

#   description          = <<-EOT
#       # OpenBSD VM Testing ISO Launch
#       Created with Terraform and Proxmox Provider

#       ## Access
#       SSH Access is up to the installtion user
#   EOT

#   # Networking
#   network {
#     id       = 0
#     model    = "virtio"
#     bridge   = var.bridge.wifi_5g
#     firewall = false
#   }

#   # Disks
#   disks {
#     ide {
#       ide2 {
#         cdrom {
#           iso = var.vm_iso.openbsd_76
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
#     }
#   }

#  tags = "openbsd;testing;${var.common_tags.vm};terraform"
# }
