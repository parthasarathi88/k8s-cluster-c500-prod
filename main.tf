resource "vsphere_virtual_machine" "vm" {
  count             = 3
  name              = "c500k8sn${count.index + 1}"
  folder            = "terraform-k8s-folder"
  resource_pool_id  = data.vsphere_resource_pool.pool[count.index].id
  datastore_id      = data.vsphere_datastore.datastore[count.index].id
  num_cpus          = 2
  memory            = 2048
  guest_id          = "ubuntu64Guest"
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }
  disk {
    label = "disk0"
    size  = 20
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "c500k8sn${count.index + 1}"
        domain    = "dellpc.in"
      }

      network_interface {
        ipv4_address = "var.ip_addresses[count.index]"
        ipv4_netmask = 24
      }

      ipv4_gateway = "var.gateway"
    }
  }

  extra_config = {
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/template/cloud_init.tpl", {
      hostname     = "c500k8sn${count.index + 1}"
      interface    = "eth0"
      ip_addresses = var.ip_addresses[count.index]
      gateway      = var.gateway
      nameservers  = ["192.168.1.225", "8.8.4.4"]
      ssh_key      = var.ssh_key
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}