# Staging Environment Outputs

output "vm_names" {
  description = "Names of the created virtual machines"
  value       = module.compute.vm_names
}

output "vm_ips" {
  description = "IP addresses of the created virtual machines"
  value       = module.compute.vm_ips
}

output "vm_ids" {
  description = "IDs of the created virtual machines"
  value       = module.compute.vm_ids
}

output "network_info" {
  description = "Network configuration information"
  value = {
    network_name = module.network.network_name
    gateway      = var.gateway
    dns_servers  = var.dns_servers
    domain_name  = var.domain_name
  }
}

output "datastore_info" {
  description = "Datastore information"
  value = {
    datastore_names = module.storage.datastore_names
    datastore_ids   = module.storage.datastore_ids
  }
}

output "ssh_connection_info" {
  description = "SSH connection information for the VMs"
  value = [
    for i in range(var.vm_count) : {
      vm_name    = "${var.vm_name_prefix}-${i + 1}"
      ip_address = var.vm_ips[i]
      username   = var.vm_user
      ssh_command = "ssh ${var.vm_user}@${var.vm_ips[i]}"
    }
  ]
  sensitive = false
}
