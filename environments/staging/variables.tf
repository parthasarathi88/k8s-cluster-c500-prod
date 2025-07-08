# Staging Environment Variables

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

# VM Configuration
variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 2  # Staging uses fewer VMs
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "staging-k8s"
}

variable "vm_cpus" {
  description = "Number of CPUs per VM"
  type        = number
  default     = 2  # Smaller resources for staging
}

variable "vm_memory" {
  description = "Memory per VM in MB"
  type        = number
  default     = 4096  # Smaller resources for staging
}

variable "vm_disk_size" {
  description = "Disk size per VM in GB"
  type        = number
  default     = 20  # Match working config
}

variable "vm_template" {
  description = "VM template name"
  type        = string
  default     = "templates/centos7"  # Using same template as working config
}

variable "vm_folder" {
  description = "vSphere folder for VMs"
  type        = string
  default     = "terraform-k8s-folder"  # Using same folder as working config
}

# Network Configuration
variable "network_name" {
  description = "Name of the vSphere network"
  type        = string
  default     = "192.168.1.1"
}

variable "gateway" {
  description = "Network gateway IP address"
  type        = string
  default     = "192.168.1.1"
}

variable "dns_servers" {
  description = "List of DNS server IP addresses"
  type        = list(string)
  default     = ["192.168.1.225", "8.8.4.4"]  # Match original working config exactly
}

variable "domain_name" {
  description = "Domain name for VMs"
  type        = string
  default     = "dellpc.in"  # Match working config
}

variable "vm_ips" {
  description = "Static IP addresses for VMs"
  type        = list(string)
  default     = [
    "192.168.1.151",  # staging-k8s-1
    "192.168.1.152"   # staging-k8s-2
  ]
}

# Storage Configuration
variable "datastores" {
  description = "List of available datastores"
  type        = list(string)
  default     = ["ds-4-ssd-az1", "ds-2-ssd-az2"]  # Using same datastores as working config, but only 2 for staging
}

variable "resource_pool" {
  description = "vSphere resource pool name"
  type        = string
  default     = "c500rp"  # Using same resource pool as working config
}

# User Configuration
variable "vm_user" {
  description = "Username for VM access"
  type        = string
  default     = "partha"
}

variable "vm_password" {
  description = "Password for VM access"
  type        = string
  sensitive   = true
  default     = "Kukapilla@1269"
}

variable "ssh_public_key" {
  description = "SSH public key for authentication"
  type        = string
  default     = ""
}
