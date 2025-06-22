#### RETRIEVE DATA INFORMATION ON VCENTER ####

data "vsphere_datacenter" "dc" {
  name = "uswest1"
}

# If you don't have any resource pools, put "Resources" after cluster name
data "vsphere_resource_pool" "pool1" {
  name          = "az1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool2" {
  name          = "az2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool3" {
  name          = "az3"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Retrieve datastore information on vsphere
data "vsphere_datastore" "az1-ssd-datastore" {
  name          = "datastore-3-ssd-200G-az1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "az2-ssd-datastore" {
  name          = "ds-2-ssd-az2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "az3-ssd-datastore" {
  name          = "ds-2-ssd-az3"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Retrieve network information on vsphere
data "vsphere_network" "network-pri1" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network-pub" {
  name          = "192.168.1.1"
  #name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Retrieve template information on vsphere
data "vsphere_virtual_machine" "template" {
  name          = "templates/ubuntu20"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vault_generic_secret" "ssh_creds" {
  path = "secret/terraform_vsphere"
}

data "vsphere_folder" "folder" {
  path          = "terraform-k8s-folder"
  #type          = "vm"
  #datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#### VM CREATION ####
