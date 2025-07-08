# Storage Module Outputs
output "datastore_ids" {
  description = "List of datastore IDs"
  value       = data.vsphere_datastore.datastore[*].id
}

output "datastore_names" {
  description = "List of datastore names"
  value       = data.vsphere_datastore.datastore[*].name
}
