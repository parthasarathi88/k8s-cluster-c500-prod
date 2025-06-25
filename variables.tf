variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 3
}

variable "vm_names" {
  description = "List of names for the virtual machines"
  type        = list(string)
  default     = ["c500k8sn1", "c500k8sn2", "c500k8sn3"]
}

variable "template_name" {
  description = "Name of the VM template to use"
  type        = string
  default     = "templates/centos7"
}

variable "network_name" {
  description = "Name of the network to attach the VMs"
  type        = string
  default     = "192.168.1.1"
}

variable "resource_pools" {
  description = "List of resource pools to use for the VMs"
  type        = list(string)
  default     = ["az1", "az2", "az3"]
}

variable "datastores" {
  description = "List of datastores to use for the VMs"
  type        = list(string)
  default     = ["ds-4-ssd-az1", "ds-2-ssd-az2", "ds-2-ssd-az3"]
}

variable "ip_addresses" {
  description = "Static IP addresses for the VMs"
  type        = list(string)
  default     = ["192.168.1.141", "192.168.1.142", "192.168.1.145"]
}

variable "datacenter_name" {
  description = "Name of the vSphere datacenter"
  type        = string
  default     = "uswest1"
}

variable "gateway" {
  description = "Gateway IP address for the VMs"
  type        = string
  default     = "192.168.1.1"
}

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