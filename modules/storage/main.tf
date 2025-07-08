# Storage Data Sources
data "vsphere_datastore" "datastore" {
  count         = var.vm_count
  name          = var.datastores[count.index]
  datacenter_id = var.datacenter_id
}
