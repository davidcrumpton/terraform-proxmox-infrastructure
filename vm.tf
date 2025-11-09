# resource "proxmox_vm_qemu" "pxe-minimal-example" {
#     name                      = "pxe-minimal-example"
#     agent                     = 0
#     boot                      = "order=net0"
#     pxe                       = true
#     target_node               = "pve02"
#     network {
#         id = 0
#         bridge    = "vmbr0"
#         firewall  = false
#         link_down = false
#         model     = "virtio"
#     }
# }

# resource "proxmox_vm_qemu" "k8s_node" {
#   name        = "minimalk8s"
#   target_node = "pve02"
#   clone       = "knode01"
#   full_clone  = true

#   memory  = "512"
#   cpu { cores = 1 }

#   # Enable the QEMU Guest Agent if template supports it
#   agent = 1

#   # Boot from the primary disk
#   boot = "order=scsi0"

#   network {
#     id        = 0
#     model     = "virtio"
#     bridge    = "vmbr0"
#     firewall  = false
#     link_down = false
#   }

#   disk {
#     slot     = "scsi0"
#     size     = "2G"
#     type     = "disk"
#     storage  = "local-lvm"
#     format   = "qcow2"
#   }
# }

# resource "proxmox_vm_qemu" "minimal_example" {
#   name        = "minimal-iso-boot"
#   target_node = "pve02"
#   memory      = 1024
#   cpu { cores = 1 }

#   # Boot CD-ROM first for installation
#   boot = "order=ide2;scsi0"

#   # Networking
#   network {
#     id       = 0
#     model    = "virtio"
#     bridge   = "vmbr0"
#     firewall = false
#   }

#   # Disks
#   disks {
#     ide {
#       ide2 {
#         cdrom {
#           iso = "local:iso/install76.iso"
#         }
#       }
#     }

#     scsi {
#       scsi0 {
#         disk {
#           size    = "2G"
#           storage = "local-lvm"
#         }
#       }
#     }
#   }
# }
