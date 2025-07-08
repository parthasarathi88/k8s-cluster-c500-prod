# Network Module Outputs
output "network_id" {
  description = "The network ID"
  value       = data.vsphere_network.network.id
}

output "network_name" {
  description = "The network name"
  value       = data.vsphere_network.network.name
}

output "gateway" {
  description = "Gateway IP address"
  value       = var.gateway
}

output "dns_servers" {
  description = "DNS servers list"
  value       = var.dns_servers
}

output "domain_name" {
  description = "Domain name"
  value       = var.domain_name
}
