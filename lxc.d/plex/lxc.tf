resource "proxmox_lxc" "plex" {
  vmid        = var.vmid
  hostname    = var.hostname
  ostype      = "ubuntu"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged = true
  protection  = true
  features    { nesting = true }
  ssh_public_keys = var.ssh_public_keys
  password = var.default_password
  start = var.start_after_creation
  onboot      = var.start_on_boot
  tags        = "media;public"

  cores  = var.cores
  memory = var.memory
  swap   = var.swap

  target_node = "pve02"

  # Root filesystem
  rootfs {
    storage = var.rootfs_storage
    size    = var.rootfs_size
  }

  # Media mount
  mountpoint {
    key      = 1
    slot     = 0
    storage  = var.media_storage
    mp       = "/media"
    size     = var.media_size
    backup   = true
  }

  # Network
  network {
    name     = "eth0"
    bridge   = var.bridge
    type     = "veth"
    ip       = "dhcp"
    ip6      = "dhcp"
    firewall = true
    hwaddr   = "22:25:64:14:fa:0a"
  }

  # ### GPU Passthrough (Modern Recommended Method)
  # lxc {
  #   key   = "lxc.cgroup2.devices.allow"
  #   value = "c 226:* rwm"
  # }

  # lxc {
  #   key   = "lxc.mount.entry"
  #   value = "/dev/dri dev/dri none bind,optional,create=dir"
  # }

  ### Legacy Method (Matches Original Proxmox Config) — Disabled
  # lxc {
  #   key   = "lxc.mount.entry"
  #   value = "/dev/dri/renderD128 dev/dri/renderD128 none bind,uid=999,gid=990,create=file"
  # }
  #
  # lxc {
  #   key   = "lxc.mount.entry"
  #   value = "/dev/dri/card1 dev/dri/card1 none bind,uid=999,gid=990,create=file"
  # }
  #
  # lxc {
  #   key   = "lxc.cgroup2.devices.allow"
  #   value = "c 226:128 rwm"
  # }
  #
  # lxc {
  #   key   = "lxc.cgroup2.devices.allow"
  #   value = "c 226:1 rwm"
  # }
}
