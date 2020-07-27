variable "prefix" {
    default = "ptc-app"
}

variable "opsPrefix" {
    default = "ptc-cicd"
}

variable "ntwkPrefix" {
    default = "shr-ntwk"
}

variable "tags" {
    type = "map"
    default = {}
}

variable "environment" {
    default = "dev"
}

variable "location" {
    default = "eastus"
}

variable "vm_size" {
    default = "Standard_F2"
}

variable "vm_os_publisher" {
    type = string
    default = "Canonical"
}

variable "vm_os_offer" {
    type = string
    default = "UbuntuServer"
}
variable "vm_os_sku" {
    type = string
    default = "18.04-LTS"
}
variable "vm_os_version" {
    type = string
    default = "latest"
}

variable "securityrules" {
    type  = any
default  = [
        {
          name                       = "allow_ssh"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow_http"
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "8080"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
}