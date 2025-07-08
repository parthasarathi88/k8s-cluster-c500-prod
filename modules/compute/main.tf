# Compute Data Sources
data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool_name
  datacenter_id = var.datacenter_id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = var.datacenter_id
}

# Virtual Machine Resources
resource "vsphere_virtual_machine" "vm" {
  count            = var.vm_count
  name             = var.vm_names[count.index]
  folder           = var.vm_folder
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = var.datastore_ids[count.index]
  num_cpus         = var.num_cpus
  memory           = var.memory
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  
  wait_for_guest_ip_timeout   = 5
  wait_for_guest_net_timeout  = 5
  wait_for_guest_net_routable = true

  network_interface {
    network_id   = var.network_id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = var.disk_size
    thin_provisioned = true
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    
    customize {
      linux_options {
        host_name = var.vm_names[count.index]
        domain    = var.domain_name
      }

      network_interface {
        ipv4_address = var.ip_addresses[count.index]
        ipv4_netmask = 24
        dns_domain   = var.domain_name
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
      dns_suffix_list = [var.domain_name]
    }
  }

  # Post-deployment configuration
  provisioner "local-exec" {
    command = "${path.module}/../../scripts/configure-vm.sh ${self.default_ip_address} ${var.vm_user} ${var.vm_password} ${self.name}"
  }
}
