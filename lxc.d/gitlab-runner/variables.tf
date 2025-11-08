variable "vmid" {
  description = "VM ID for the LXC container"
  type        = number
  default     = 117
}

variable "node" {
  description = "Proxmox node where the LXC will be created"
  type        = string
  default     = "pve02"
}
variable "hostname" {
  description = "Hostname of the LXC container"
  type        = string
  default     = "gitlab-runner"
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 4
}

variable "memory" {
  description = "RAM in MB"
  type        = number
  default     = 928
}

variable "swap" {
  description = "Swap memory in MB"
  type        = number
  default     = 512
}

variable "rootfs_storage" {
  description = "Storage pool for root filesystem"
  type        = string
  default     = "local-lvm"
}

variable "rootfs_size" {
  description = "Size of root filesystem"
  type        = string
  default     = "80G"
}

variable "media_storage" {
  description = "Storage pool for media mountpoint"
  type        = string
  default     = "media"
}

variable "media_size" {
  description = "Size of media mountpoint"
  type        = string
  default     = "4100G"
}

variable "bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}
