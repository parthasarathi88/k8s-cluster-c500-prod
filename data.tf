#Datacenter
data "vsphere_datacenter" "dc" {
  name = var.datacenter_name
}

# Resource pool
data "vsphere_resource_pool" "pool" {
  count = 3
  name  = var.resource_pools[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

#datastore
data "vsphere_datastore" "datastore" {
  count = 3
  name  = var.datastores[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

# template
data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Network
data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}
