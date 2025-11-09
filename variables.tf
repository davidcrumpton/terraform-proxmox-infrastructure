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

variable "default_ssh_keys" {
  default = <<-EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL8YquRYjxB123uSqoeLyjFmtnj5pi9x+mV2eb/Jvlr/oLarNX2/alC5VjpRRtqh+INmOhofgqlW479MClvrvNoFoz8vLcuL0Ppwc3+svBNODGEA5E1rQg+JU4rq8Z0ptDWQjxMN/KQ8g+sp2icA90f+HyONy8jw6vaB1ZR65qtTiVwiKavoXJwehvikeVS5Exh1rgU56yOoMxzeUto0xqCleC1Exlig5oO0Hon6L0fWSWRD6jWgu2ZvjgzKZ3GZwJJxhwIaz2xOXMDat+gx0/msnlGqSHE3onMmRixnlRb4ToGWNB3925eGKVZq6RIbQHtXYvyWWCKBEARMIche/HvRkDAvnSFKkXI9nPEuzSHXL0FEfAhzT6nIv8wYetK3FJGJnQ6hmWRMGn/jnYldp7sLzYUK50e60tufa4I+y7334Z8xN6MZJ3yhMAGKTjaWkcFfTu+vnBf9VTJFZhu0XnrCmCU5UHPn16+S7GYdlmHWWCKfq2vyDScOaPPPzAs+/L5+ysI+OqhS/JoorYvdvljPG6SNCobxJrXeFZxRUCOBkUJFiWrHRwxNXRtwchNWv0WI6rwyGHiJoLSr2453DYx8ZnlUlaBv2kaycTxg9iyH33tZXTWYtTMN5loghMVqB0o3TgLmbgtN/dKtDPVgzdYdVSX/Zru0ElOfm3b3Hayw== cardno:000604146669
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHAB5iOtvm4nIHgFwYXpHr1tgm0jS8Mqjx54j/cG7W64LEVwF5mxBRyATZ7fVquoV9SGZuPDclwUmAsrj72Fyq2/YCOMpfpEB+dUYfbKA6/xp+WvJiE6K+JblCLIdF1LhsZqtzMq1UmrrAuiWhaR9ksaZOPYoeaAJS9MBHasVHiWnf6wbTEeuWuTxxXMHg86Cfy8sGzria+lHWWzTxAwiLgXGNkmQ39aUnqqWHzgBnRui9QDq6iFVK3ExjjChyBDENPCM/oRlNuGytALLI+JazKDLVPVJZOTouW/uZlyYnLyj24Bzu3XVA+ClcqStAJ0R9R7ZV/dae53rJoiyo49jp openpgp:0xA2E070F6
  EOT
}
variable "default_password" {
  default = "SimpleLXCPassword123!"
}

variable "ostemplate_ubuntu_2204" {
  type = object({
    template = string
    ostype       = string
  })
  default = {
    template = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
    ostype       = "ubuntu"
  }
}
variable "ostemplate_debian_12" {
  type = object({
    template = string
    ostype    = string
  })
  default = {
    template = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    ostype    = "debian"
  }
}

# ubuntu 24
variable "ostemplate_ubuntu_2404" {
  type = object({
    template = string
    ostype       = string
  })
  default = {
    template = "local:vztmpl/ubuntu-24.04-standard_24.04-1_amd64.tar.zst"
    ostype       = "ubuntu"
  } 
}

variable "bridge"{
  type = object({
    lan = string
    internal = string
    wifi_5g = string
  }) 
  default = {
    lan = "vmbr0"
    internal = "vmbr1"
    wifi_5g = "vmbr10"
  }
}

variable "storage_pool"{
  type = object({
    local = string
    zfs = string
    directory_media = string
  }) 
  default = {
    local = "local-lvm"
    zfs = "local-zfs"
    directory_media = "media"
  }
}

variable "common_tags"{
  type = object({
    lxc = string
    vm = string
    docker_in_lxc = string
  }) 
  default = {
    lxc = "lxc"
    vm = "VM"
    docker_in_lxc = "lxc-docker"
  }
}

variable "lxc_sizing"{
  type = object({
    xlarge = object({
      memory = number
      cores  = number
      swap   = number
      disk   = number
    })
    large = object({
      memory = number
      cores  = number
      swap   = number
      disk   = number
    })
    medium = object({
      memory = number
      cores  = number
      swap   = number
      disk   = number
    })
    small = object({
      memory = number
      cores  = number
      swap   = number
      disk   = number
    })
    tiny = object({
      memory = number
      cores  = number
      swap   = number
      disk   = number
    })  
  }) 
  default = {
    xlarge = {
      memory = 4096
      cores  = 8
      swap   = 8192
      disk   = 1024
    }
    large = {
      memory = 2048
      cores  = 4
      swap   = 4096
      disk   = 1024
    }
    medium = {
      memory = 1024
      cores  = 2
      swap   = 2048
      disk   = 1024
    }
    small = {
      memory = 512
      cores  = 2
      swap   = 1024
      disk   = 1024
    }
    tiny = {
      memory = 256
      cores  = 1
      swap   = 512
      disk   = 1024
    }
  }
}