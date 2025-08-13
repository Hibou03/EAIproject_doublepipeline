variable "vsphere_user" {
  type        = string
}

variable "vsphere_password" {
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  type        = string
}

variable "datacenter" {
  type        = string
}

variable "datastore" {
  type        = string
}

variable "cluster" {
  type        = string
}

variable "network" {
  type        = string
}

variable "template" {
  type        = string
}

variable "vm_name" {
  type        = string
}

variable "ipv4_adress" {
  type        = string
}

variable "ipv4_gateway" {
  type        = string
}
