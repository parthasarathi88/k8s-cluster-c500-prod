# Production Environment Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

# vSphere Provider Configuration
provider "vsphere" {
  user                 = var.vcenter_user
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true
}

# Data Sources
data "vsphere_datacenter" "dc" {
  name = var.datacenter_name
}

# Network Module
module "network" {
  source = "../../modules/network"
  
  datacenter_id = data.vsphere_datacenter.dc.id
  network_name  = var.network_name
  gateway       = var.gateway
  dns_servers   = var.dns_servers
  domain_name   = var.domain_name
}

# Storage Module
module "storage" {
  source = "../../modules/storage"
  
  datacenter_id = data.vsphere_datacenter.dc.id
  datastores    = var.datastores
  vm_count      = var.vm_count
}

# Compute Module
module "compute" {
  source = "../../modules/compute"
  
  datacenter_id      = data.vsphere_datacenter.dc.id
  resource_pool_name = var.resource_pool
  template_name      = var.template_name
  vm_count           = var.vm_count
  vm_names           = var.vm_names
  vm_folder          = var.vm_folder
  num_cpus           = var.num_cpus
  memory             = var.memory
  disk_size          = var.disk_size
  
  # Network configuration
  network_id    = module.network.network_id
  ip_addresses  = var.ip_addresses
  gateway       = module.network.gateway
  dns_servers   = module.network.dns_servers
  domain_name   = module.network.domain_name
  
  # Storage configuration
  datastore_ids = module.storage.datastore_ids
  
  # VM credentials
  vm_user        = var.vm_user
  vm_password    = var.vm_password
  ssh_public_key = var.ssh_public_key
}
