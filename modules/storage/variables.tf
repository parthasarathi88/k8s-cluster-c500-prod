# Storage Module Variables
variable "datacenter_id" {
  description = "The datacenter ID where storage resources will be created"
  type        = string
}

variable "datastores" {
  description = "List of datastores to use for the VMs"
  type        = list(string)
}

variable "vm_count" {
  description = "Number of VMs (determines how many datastores to configure)"
  type        = number
}
