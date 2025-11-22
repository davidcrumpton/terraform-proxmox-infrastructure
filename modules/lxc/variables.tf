# SPDX-License-Identifier: MIT

variable "node" {}
variable "vmid" {}
variable "hostname" {}
variable "cores" { default = 1 }
variable "memory" { default = 512 }
variable "swap" { default = 256 }
variable "ostemplate" {}
variable "root_password" { sensitive = true }
variable "ssh_public_keys" { default = "" }
variable "tags" { type = list(string) }
variable "features_nesting" { default = true }
variable "features_keyctl" { default = false }
variable "storage_pool" {}
variable "disk_size" { default = "8G" }
variable "description" { default = "" }
variable "unprivileged" { default = "true" }
  

variable "networks" {
  description = "List of network interfaces"
  type = list(object({
    name    = string
    bridge  = string
    ip      = string
    ip6     = string
  }))
}
