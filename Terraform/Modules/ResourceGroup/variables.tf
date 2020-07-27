variable "name" {
  type        = string
  description = "the resource group name"
}

variable "location" {
  type        = string
  description = "the resource group location"
  default     = "eastus"
}

variable "tags" {
  type        = map
  description = "the resource tags"
  default     = {}
}

variable "Environment" {
    type = string
    description = "Environment or workspace name"
    default = "dev"
}