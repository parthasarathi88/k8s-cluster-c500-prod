# Staging Environment Configuration
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
  template_name      = var.vm_template
  network_id         = module.network.network_id
  datastore_ids      = module.storage.datastore_ids
  
  # VM Configuration
  vm_count    = var.vm_count
  vm_names    = ["staging-k8sn1", "staging-k8sn2"]  # Match working config naming pattern
  num_cpus    = var.vm_cpus
  memory      = var.vm_memory
  disk_size   = var.vm_disk_size
  
  # Network Configuration
  ip_addresses   = var.vm_ips
  gateway        = var.gateway
  dns_servers    = var.dns_servers
  domain_name    = var.domain_name
  
  # User Configuration
  vm_user        = var.vm_user
  vm_password    = var.vm_password
  ssh_public_key = var.ssh_public_key
  
  # Folder configuration
  vm_folder = var.vm_folder
}
