resource "vsphere_virtual_machine" "vm" {
  count           = 3
  name            = "c500k8sn${count.index + 1}"
  folder          = "terraform-k8s-folder"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore[count.index].id
  num_cpus         = 2
  memory           = 4096
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  
  wait_for_guest_ip_timeout      = 5
  wait_for_guest_net_timeout     = 5
  wait_for_guest_net_routable    = true

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 20
    thin_provisioned = true
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    
    customize {
      linux_options {
        host_name = "c500k8sn${count.index + 1}"
        domain    = "dellpc.in"
      }

      network_interface {
        ipv4_address = var.ip_addresses[count.index]
        ipv4_netmask = 24
        dns_domain   = "dellpc.in"
      }

      ipv4_gateway = var.gateway
      dns_server_list = var.dns_servers
      dns_suffix_list = ["dellpc.in"]
    }
  }
}