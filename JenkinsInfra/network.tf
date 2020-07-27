data "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  resource_group_name  = local.network_rg_name
  virtual_network_name = local.vnet_name
}

data "template_file" "cloudinit" {
  template = file("${path.root}/templates/cloudint.sh.tpl")

  vars = {
    KV_NAME = module.KV.name,
    TLS_PRIVATE_KEY = local.tls_private_key
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content = data.template_file.cloudinit.rendered
  }
}

resource "azurerm_network_security_group" "allows" {
  name                = "${local.build_vm}-nsg"
  location            = module.rg.location
  resource_group_name = module.rg.name
  tags                = local.tags

  dynamic "security_rule" {
    for_each = var.securityrules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
  
}

resource "azurerm_public_ip" "pip" {
  name                  = "${local.build_vm}-pip"
  location              = module.rg.location
  resource_group_name   = module.rg.name
  sku                   = "Standard"
  allocation_method     = "Static"

  tags                  = local.tags
}

resource "azurerm_network_interface" "nic" {
  name                            = "${local.build_vm}-nic"
  location                        = module.rg.location
  resource_group_name             = module.rg.name
  tags                            = local.tags

  network_security_group_id       = azurerm_network_security_group.allows.id

  ip_configuration {
    name                          = "${local.build_vm}-nic-config"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id          = azurerm_public_ip.pip.id 
  }
  
}

resource "azurerm_virtual_machine" "vm" {
  name                  = local.build_vm
  location              = module.rg.location
  resource_group_name   = module.rg.name
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = var.vm_size
  tags                  = var.tags

  identity {
    type = "UserAssigned"
    identity_ids = [ 
      azurerm_user_assigned_identity.vm.id
    ]
  }

  storage_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  os_profile {
    computer_name        = local.build_vm
    admin_username       = "adminuser"
    
    custom_data          = data.template_cloudinit_config.config.rendered
  }

 os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = tls_private_key.vm.public_key_openssh
    }
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  lifecycle {
    ignore_changes = [ 
      os_profile
    ]
  }

  depends_on = [
    azurerm_key_vault_secret.jenkins_pass
  ]
}