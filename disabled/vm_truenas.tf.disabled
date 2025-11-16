resource "proxmox_vm_qemu" "truenas" {
  name        = "truenas"
  target_node = "pve02"
  memory      = 8192
  cpu { cores = 4 }
  tags        = "lab"
  description = <<-EOT
# TrueNAS

TrueNAS 25.10

EOT

  # Boot CD-ROM first for installation
  boot = "order=ide2;scsi0"

  # Networking
  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  # Disks
  disks {
    ide {
      ide2 {
        cdrom {
          # iso = "local:iso/TrueNAS-SCALE-25.10.0.iso"
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size    = var.vm_sizing.small.disk
          storage = "local-lvm"
          serial  = "CO0ZFSD"
        }
      }
      scsi1 {
        disk {
          size    = 256
          storage = "local-zfsd"
          serial  = "CO1ZFSD"
        }
      }
      scsi2 {
        disk {
          size    = 256
          storage = "local-zfse"
          serial  = "CO2ZFSD"
        }
      }
      scsi3 {
        disk {
          size    = 256
          storage = "local-zfsf"
          serial  = "CO3ZFSD"
        }
      }
    }
  }
}
