variable "rgPrefix" {
    default = "shr-ntwk"
}

variable "ntwkPrefix" {
    default = "shr-ntwk"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "environment" {
    default = "dev"
}

variable "location" {
    default = "eastus"
}

variable "vnet_cidr" {
    type = string
     default = "172.20.0.0/16"
}

variable "subnets" {
  description = ""
  default     =  {
     "subnet1" = {
          name                  = "ptc-cicd-snt"
          address_prefix        = "172.20.10.0/24"
          service_endpoints     = ["Microsoft.KeyVault",  "Microsoft.Storage"]
          nsg_name = ""
  },
  "subnet2" = {
          name                  = "ptc-app-snt"
          address_prefix        = "172.20.20.0/24"
          service_endpoints     = ["Microsoft.KeyVault",  "Microsoft.Storage"]
          nsg_name = ""
  }
  }
}