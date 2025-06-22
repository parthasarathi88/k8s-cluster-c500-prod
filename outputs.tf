output "vm_ips" {
  value = [for vm in vsphere_virtual_machine.vm : vm.default_ip_address]
}

output "vm_names" {
  value = [for vm in vsphere_virtual_machine.vm : vm.name]
}