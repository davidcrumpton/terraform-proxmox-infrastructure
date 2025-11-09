# module "plex" {
#   source = "./lxc.d/plex"
 
#   ssh_public_keys = var.default_ssh_keys
#   vmid            = 117
#   hostname        = "plexing"
#   cores           = 4
#   memory          = 928
#   swap            = 512
#   rootfs_storage  = "local-lvm"
#   rootfs_size     = "80G"
#   media_storage   = "media"
#   media_size      = "4100G"
#   bridge          = "vmbr0"
# }
module "simple_lxc" {
  source = "./lxc.d/simple-lxc"

  ssh_public_keys = var.default_ssh_keys
  default_password = random_password.lxc_root_password.result
  vmid            = 199
  hostname        = "simple-lxc"
  cores           = 4
  memory          = 928
  swap            = 512
  rootfs_storage  = "local-lvm"
  rootfs_size     = "8G"
  bridge          = "vmbr0"
}


# module "gitlab_runner" {
#   source = "./lxc.d/gitlab-runner"

#   ssh_public_keys = var.default_ssh_keys
#   vmid            = 107
#   hostname        = "gitlab-running"
#   cores           = 4
#   memory          = 928
#   swap            = 512
#   rootfs_storage  = "local-lvm"
#   rootfs_size     = "8G"
#   bridge          = "vmbr0"
# }
# resource "proxmox_lxc" "basic" {
#   target_node  = "pve02"
#   hostname     = "lxc-basic"
#   ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
#   password     = "BasicLXCContainer"
#   unprivileged = true

#   // Terraform will crash without rootfs defined
#   rootfs {
#     storage = "local-lvm"
#     size    = "8G"
#   }

#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "dhcp"
#   }
#   tags = "terraform;basic;example"
# }

# resource "proxmox_lxc_guest" "minimal-example" {
#     name         = "minimal-example"
#     power_state  = "running"
#     target_node         = "pve02"
#     unprivileged = true
#     password     = "yourpassword"
#     template {
#         file    = "ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
#         storage = "local"
#     }
#     cpu {
#         cores = 1
#     }
#     memory = 1024
#     swap   = 512
#     pool   = "my-pool"
#     root_mount {
#         size    = "4G"
#         storage = "local-lvm"
#     }
#     network {
#         id = 0
#         name = "eth0"
#         bridge = "vmbr0"
#         ipv4_address = "192.168.1.100/24"
#         ipv4_gateway = "192.168.1.1"
#     }
#     tags = [ "terraform", "basic", "example" ]
# }

# resource "proxmox_lxc" "multiple_mountpoints" {
#   target_node  = "pve"
#   hostname     = "lxc-multiple-mountpoints"
#   ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
#   unprivileged = true
#   ostype       = "ubuntu"

#   ssh_public_keys = var.default_ssh_keys

#   // Terraform will crash without rootfs defined
#   rootfs {
#     storage = "local-lvm"
#     size    = "8G"
#   }

#   // Storage Backed Mount Point
#   mountpoint {
#     key     = "0"
#     slot    = 0
#     storage = "local-lvm"
#     mp      = "/mnt/container/storage-backed-mount-point"
#     size    = "12G"
#   }

#   // Bind Mount Point
#   mountpoint {
#     key     = "1"
#     slot    = 1
#     storage = "/srv/host/bind-mount-point"
#     // Without 'volume' defined, Proxmox will try to create a volume with
#     // the value of 'storage' + : + 'size' (without the trailing G) - e.g.
#     // "/srv/host/bind-mount-point:256".
#     // This behaviour looks to be caused by a bug in the provider.
#     volume  = "/srv/host/bind-mount-point"
#     mp      = "/mnt/container/bind-mount-point"
#     size    = "256G"
#   }

#   // Device Mount Point
#   mountpoint {
#     key     = "2"
#     slot    = 2
#     storage = "/dev/sdg"
#     volume  = "/dev/sdg"
#     mp      = "/mnt/container/device-mount-point"
#     size    = "32G"
#   }

#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "dhcp"
#     ip6    = "dhcp"
#   }
# }