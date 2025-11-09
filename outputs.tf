# output root password

output "lxc_root_password" {
  description = "Root password for the LXC container"
  value       = random_password.lxc_root_password.result
  sensitive   = true
}


output "ns1_root_password" {
  description = "Root password for the NS1 container"
  value       = random_password.ns1_root_password.result
  sensitive   = true
}


output "simple_root_password" {
  description = "Root password for the simple LXC container"
  value       = random_password.simple_root_password.result
  sensitive   = true
}

output "debian_root_password" {
  description = "Root password for the Debian LXC container"
  value       = random_password.debian_root_password.result
  sensitive   = true
}