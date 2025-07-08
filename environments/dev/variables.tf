# Development Environment Variables

# vCenter Configuration
variable "vcenter_user" {
  description = "Username for vCenter authentication"
  type        = string
}

variable "vcenter_password" {
  description = "Password for vCenter authentication"
  type        = string
  sensitive   = true
}

variable "vcenter_server" {
  description = "vCenter server address"
  type        = string
}

variable "datacenter_name" {
  description = "Name of the vSphere datacenter"
  type        = string
  default     = "uswest1"
}

# VM Configuration - Development settings (smaller resources)
variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 2  # Fewer VMs for development
}

variable "vm_names" {
  description = "List of names for the virtual machines"
  type        = list(string)
  default     = ["c500k8s-dev1", "c500k8s-dev2"]  # Different naming for dev
}

variable "vm_folder" {
  description = "VM folder name"
  type        = string
  default     = "terraform-k8s-dev"  # Different folder for dev
}

variable "template_name" {
  description = "Name of the VM template to use"
  type        = string
  default     = "templates/centos7"
}

variable "num_cpus" {
  description = "Number of CPUs per VM"
  type        = number
  default     = 1  # Less CPU for development
}

variable "memory" {
  description = "Memory in MB per VM"
  type        = number
  default     = 2048  # Less memory for development
}

variable "disk_size" {
  description = "Disk size in GB per VM"
  type        = number
  default     = 15  # Smaller disk for development
}

# Network Configuration
variable "network_name" {
  description = "Name of the network to attach the VMs"
  type        = string
  default     = "192.168.1.1"
}

variable "ip_addresses" {
  description = "Static IP addresses for the VMs"
  type        = list(string)
  default     = ["192.168.1.151", "192.168.1.152"]  # Different IP range for dev
}

variable "gateway" {
  description = "Gateway IP address for the VMs"
  type        = string
  default     = "192.168.1.1"
}

variable "dns_servers" {
  description = "List of DNS servers for the VMs"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "domain_name" {
  description = "Domain name for VMs"
  type        = string
  default     = "dev.dellpc.in"  # Development subdomain
}

# Infrastructure Configuration
variable "resource_pool" {
  description = "Resource pool to use for all VMs"
  type        = string
  default     = "c500rp"
}

variable "datastores" {
  description = "List of datastores to use for the VMs"
  type        = list(string)
  default     = ["ds-4-ssd-az1", "ds-2-ssd-az2"]  # Only 2 datastores for dev
}

# VM Credentials
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
