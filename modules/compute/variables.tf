# Compute Module Variables
variable "datacenter_id" {
  description = "The datacenter ID where compute resources will be created"
  type        = string
}

variable "resource_pool_name" {
  description = "Resource pool name to use for VMs"
  type        = string
}

variable "template_name" {
  description = "Name of the VM template to use"
  type        = string
}

variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
}

variable "vm_names" {
  description = "List of names for the virtual machines"
  type        = list(string)
}

variable "vm_folder" {
  description = "VM folder name"
  type        = string
  default     = ""
}

variable "num_cpus" {
  description = "Number of CPUs per VM"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB per VM"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size in GB per VM"
  type        = number
  default     = 20
}

variable "network_id" {
  description = "Network ID to attach VMs to"
  type        = string
}

variable "datastore_ids" {
  description = "List of datastore IDs for VMs"
  type        = list(string)
}

variable "ip_addresses" {
  description = "Static IP addresses for the VMs"
  type        = list(string)
}

variable "gateway" {
  description = "Gateway IP address for the VMs"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers for the VMs"
  type        = list(string)
}

variable "domain_name" {
  description = "Domain name for VMs"
  type        = string
}

variable "vm_user" {
  description = "Username for the VM"
  type        = string
}

variable "vm_password" {
  description = "Password for the VM user"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for the VM user"
  type        = string
  default     = ""
}
