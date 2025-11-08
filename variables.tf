variable "pm_api_url" {
  type = string
  description = "ProxMox API URL (https://host:8006/api2/json). Can be set via PM_API_URL env var."
  default = ""
}

variable "pm_user" {
  type = string
  description = "ProxMox username (e.g. root@pam or terraform@pve). Can be set via PM_USER env var."
  default = ""
}

variable "pm_password" {
  type = string
  description = "ProxMox password (prefer token). Can be set via PM_PASSWORD env var."
  default = ""
  sensitive = true
}

variable "pm_api_token_id" {
  type = string
  description = "ProxMox API token id (preferred). Can be set via PM_API_TOKEN_ID env var."
  default = ""
}

variable "pm_api_token_secret" {
  type = string
  description = "ProxMox API token secret. Can be set via PM_API_TOKEN_SECRET env var."
  default = ""
  sensitive = true
}

variable "pm_tls_insecure" {
  type = bool
  default = false
}

variable "datacenter" { 
  type = string
   default = "pve" 
   }
variable "node" { 
  type = string
 default = "node1" 
 }
variable "storage" { 
  type = string
 default = "local-lvm" 
 }

# VM defaults
variable "vm_name" {
   type = string
 default = "terraform-vm" 
 }
variable "cores" { 
  type = number
 default = 2 
 }
variable "memory" {
   type = number
    default = 2048 
    }
variable "disk_size_gb" {
   type = number
   default = 16 
   }
