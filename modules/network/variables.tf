# Network Module Variables
variable "datacenter_id" {
  description = "The datacenter ID where network resources will be created"
  type        = string
}

variable "network_name" {
  description = "Name of the network to attach the VMs"
  type        = string
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
  description = "Domain name for the network"
  type        = string
  default     = "dellpc.in"
}
