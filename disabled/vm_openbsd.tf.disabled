resource "proxmox_vm_qemu" "minimal_example" {
  name        = "openbsd-ng"
  target_node = "pve02"
  memory      = var.vm_sizing.small.memory
  cpu { cores = var.vm_sizing.small.cores }
  tags        = "lab"
  description = <<-EOT
# openbsd-ng

Next Gen OpenBSD

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
          iso = var.vm_iso.openbsd_76
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size    = var.vm_sizing.small.disk
          storage = "local-lvm"
          serial  = "SCSI10001DA"
        }
      }
    }
  }
}

