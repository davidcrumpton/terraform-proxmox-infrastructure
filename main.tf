terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

provider "proxmox" {
  # You can provide credentials via variables (below) or via the provider's
  # environment variables (PM_API_URL, PM_USER, PM_PASSWORD, PM_API_TOKEN_ID,
  # PM_API_TOKEN_SECRET, PM_TLS_INSECURE). The provider will use what is
  # available — prefer token-based auth for automation.

  pm_api_url       = var.pm_api_url        # e.g. "https://proxmox.example:8006/api2/json"
  pm_user          = var.pm_user           # e.g. "root@pam" or "terraform@pve"
  pm_password      = var.pm_password       # optional when using token
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure  = var.pm_tls_insecure
}

# generate random root password of 24 characters

resource "random_password" "lxc_root_password" {
  length           = 24
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  special          = true
} 







# resource "proxmox_lxc" "nextsuite" {
#   # (resource arguments)
# }

# resource "proxmox_lxc" "docker02" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "gitlab" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "atom5g" {
#   # (resource arguments)
# }

# resource "proxmox_lxc" "gl-runner-01" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "git" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "opensearch" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "influxd" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "sso" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "wiki" {
#   # (resource arguments)
# }


# resource "proxmox_lxc" "elk" {
#   # (resource arguments)
# }

# resource "proxmox_lxc" "pve01-backup" {
#   # (resource arguments)
# }

# resource "proxmox_lxc" "simple-lxc" {
#   # (resource arguments)
# }

# resource "proxmox_lxc" "plex" {
#   # (resource arguments)
# }