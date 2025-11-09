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

variable "ssh_public_keys" {
  default = <<-EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL8YquRYjxB123uSqoeLyjFmtnj5pi9x+mV2eb/Jvlr/oLarNX2/alC5VjpRRtqh+INmOhofgqlW479MClvrvNoFoz8vLcuL0Ppwc3+svBNODGEA5E1rQg+JU4rq8Z0ptDWQjxMN/KQ8g+sp2icA90f+HyONy8jw6vaB1ZR65qtTiVwiKavoXJwehvikeVS5Exh1rgU56yOoMxzeUto0xqCleC1Exlig5oO0Hon6L0fWSWRD6jWgu2ZvjgzKZ3GZwJJxhwIaz2xOXMDat+gx0/msnlGqSHE3onMmRixnlRb4ToGWNB3925eGKVZq6RIbQHtXYvyWWCKBEARMIche/HvRkDAvnSFKkXI9nPEuzSHXL0FEfAhzT6nIv8wYetK3FJGJnQ6hmWRMGn/jnYldp7sLzYUK50e60tufa4I+y7334Z8xN6MZJ3yhMAGKTjaWkcFfTu+vnBf9VTJFZhu0XnrCmCU5UHPn16+S7GYdlmHWWCKfq2vyDScOaPPPzAs+/L5+ysI+OqhS/JoorYvdvljPG6SNCobxJrXeFZxRUCOBkUJFiWrHRwxNXRtwchNWv0WI6rwyGHiJoLSr2453DYx8ZnlUlaBv2kaycTxg9iyH33tZXTWYtTMN5loghMVqB0o3TgLmbgtN/dKtDPVgzdYdVSX/Zru0ElOfm3b3Hayw== cardno:000604146669
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHAB5iOtvm4nIHgFwYXpHr1tgm0jS8Mqjx54j/cG7W64LEVwF5mxBRyATZ7fVquoV9SGZuPDclwUmAsrj72Fyq2/YCOMpfpEB+dUYfbKA6/xp+WvJiE6K+JblCLIdF1LhsZqtzMq1UmrrAuiWhaR9ksaZOPYoeaAJS9MBHasVHiWnf6wbTEeuWuTxxXMHg86Cfy8sGzria+lHWWzTxAwiLgXGNkmQ39aUnqqWHzgBnRui9QDq6iFVK3ExjjChyBDENPCM/oRlNuGytALLI+JazKDLVPVJZOTouW/uZlyYnLyj24Bzu3XVA+ClcqStAJ0R9R7ZV/dae53rJoiyo49jp openpgp:0xA2E070F6
  EOT
}

variable "ostemplate" {
  default = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "default_password" {
  default = "undefined!RootPassword123"
  type   = string
}

variable "start_after_creation" {
  description = "Whether to start the container after creation"
  type        = bool
  default     = true
}
variable "start_on_boot" {
  description = "Whether to start the container on Proxmox host boot"
  type        = bool
  default     = true
}