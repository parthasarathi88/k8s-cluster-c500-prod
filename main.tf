resource "vsphere_virtual_machine" "k8s_nodes" {
  for_each = {
    c500k8sn1 = { ip_priv = "192.168.10.141", ip_pub = "192.168.1.141" },
    c500k8sn2 = { ip_priv = "192.168.10.142", ip_pub = "192.168.1.142" },
    c500k8sn3 = { ip_priv = "192.168.10.145", ip_pub = "192.168.1.145" }
  }

  name             = each.key
  folder           = "terraform-k8s-folder"
  num_cpus         = 2
  memory           = 4096
  datastore_id     = data.vsphere_datastore.az1-ssd-datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool1.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network-pri1.id
    adapter_type = "vmxnet3"
  }

  network_interface {
    network_id   = data.vsphere_network.network-pub.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "${each.key}.vmdk"
    size             = 50
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    
    customize {
      linux_options {
        host_name = each.key
        domain    = "dellpc.in"
      }

      # First NIC (matches first network_interface block)
      network_interface {
        ipv4_address = each.value.ip_priv
        ipv4_netmask = 24
      }
      
      # Second NIC (matches second network_interface block)
      network_interface {
        ipv4_address = each.value.ip_pub
        ipv4_netmask = 24
        dns_server_list = ["192.168.1.225", "1.1.1.1"]
        dns_domain      = "dellpc.in"
      }
      
      ipv4_gateway = "192.168.1.1"
    }
  }

  # Force wait for customization to complete
  wait_for_guest_net_timeout = 20
  wait_for_guest_ip_timeout  = 20

  # Verify network configuration
  provisioner "remote-exec" {
    inline = [
      "echo 'Network configuration:'",
      "ip -4 addr show",
      "ip route show",
      "cat /etc/resolv.conf"
    ]
    connection {
      type     = "ssh"
      user     = local.ssh_user
      password = local.ssh_password
      host     = self.default_ip_address
    }
  }
}
