variable "tags" {
  type = "map"
  default = {}
}

variable "Environment" {
  type = string
  default = "dev"
}

variable "name" {
description = "Name of Virtual network resource"
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "Azure location where resources should be deployed."
  default = ""
}

variable "vnet_cidr" {
  type        = string
  description = "The list of address spaces for the VNet."
  default = "172.20.0.0/16"
}

variable "vnet_dns_servers" {
  type        = list(string)
  description = "List of IP addresses of DNS servers"
  default     = []
}

variable "subnets" {
  description = "The virtal networks subnets with their properties."
  type        = any
  default     = {}
}

variable "nsgs" {
  description = "The location where resources will be created"
  default     =  {
    "default" = {
      rules = [
      ]
    }}
    }