# Network Data Sources
data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = var.datacenter_id
}
