output "node_ip_addresses" {
  description = "All IP addresses of the Kubernetes nodes"
  value       = [for vm in vsphere_virtual_machine.k8s_nodes : vm.guest_ip_addresses]
}