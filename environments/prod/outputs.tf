# Production Environment Outputs

output "vm_names" {
  description = "Names of the created VMs"
  value       = module.compute.vm_names
}

output "vm_ips" {
  description = "IP addresses of the created VMs"
  value       = module.compute.vm_ips
}

output "vm_ids" {
  description = "IDs of the created VMs"
  value       = module.compute.vm_ids
}

output "network_info" {
  description = "Network configuration information"
  value = {
    network_name = module.network.network_name
    gateway      = module.network.gateway
    dns_servers  = module.network.dns_servers
    domain_name  = module.network.domain_name
  }
}

output "storage_info" {
  description = "Storage configuration information"
  value = {
    datastore_names = module.storage.datastore_names
  }
}
