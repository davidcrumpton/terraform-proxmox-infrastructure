# output root password

output "lxc_root_password" {
  description = "Root password for the LXC container"
  value       = random_password.lxc_root_password.result
  sensitive   = true
}