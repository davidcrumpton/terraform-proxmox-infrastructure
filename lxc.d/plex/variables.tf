

variable "vmid" {
  description = "VMID for the Plex LXC"
  type        = number
  default     = 117
}

variable "hostname" {
  description = "Hostname for the Plex LXC"
  type        = string
  default     = "plex"
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 4
}

variable "memory" {
  description = "RAM allocated to container (MB)"
  type        = number
  default     = 928
}

variable "swap" {
  description = "Swap space allocated (MB)"
  type        = number
  default     = 512
}

variable "rootfs_storage" {
  description = "Storage for container root filesystem"
  type        = string
  default     = "local-lvm"
}

variable "rootfs_size" {
  description = "Size of root filesystem"
  type        = string
  default     = "80G"
}

variable "media_storage" {
  description = "Storage pool for media mount"
  type        = string
  default     = "media"
}

variable "media_size" {
  description = "Size of the media mount"
  type        = string
  default     = "4100G"
}

variable "bridge" {
  description = "Network bridge for the container"
  type        = string
  default     = "vmbr0"
}
