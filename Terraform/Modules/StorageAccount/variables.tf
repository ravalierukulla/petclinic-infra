variable "account_kind" {
  default = "StorageV2"
}

variable "name" {
description = "Name of storage account, if it contains illigal characters (,-_ etc) those will be truncated."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "Azure location where resources should be deployed."
  default = ""
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  default     = "Hot"
}

variable "network_rules_ip_rules" {
  description = "Network rules restricting access to storage account on IP addresses."
  type        = list(string)
  default     = []
}

variable "network_rules_subnet_ids" {
  description = "Network rules restricting access to subnets."
  type        = list(string)
  default     = []
}

variable "bypass_services" {
  description = "Network rules restricting to bypass."
  type        = list(string)
  default     = ["None"]
}

variable "is_hns_enabled" {
  default = false
}

variable "enable_blob_encryption" {
  default = true
}

variable "enable_file_encryption" {
  default = true
}
variable "enable_https_traffic_only" {
  default = true
}
variable "enable_advanced_threat_protection" {
  default = true
}

variable "containers" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "tags" {
  type = "map"
  default = {}
}

variable "Environment" {
  type = string
  default = "dev"
}
