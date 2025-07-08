# Compute Module Outputs
output "vm_ids" {
  description = "List of VM IDs"
  value       = vsphere_virtual_machine.vm[*].id
}

output "vm_names" {
  description = "List of VM names"
  value       = vsphere_virtual_machine.vm[*].name
}

output "vm_ips" {
  description = "List of VM IP addresses"
  value       = vsphere_virtual_machine.vm[*].default_ip_address
}

output "vm_guest_ip_addresses" {
  description = "List of VM guest IP addresses"
  value       = vsphere_virtual_machine.vm[*].guest_ip_addresses
}
