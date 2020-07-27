module "rg" {
  source = "./../Terraform/Modules/ResourceGroup"

  name                          = local.rg_name
  tags                          = local.tags
  location                      = var.location
}

module "KV" {
    source = "./../Terraform/Modules/KeyVault"
    name = local.app_kv_name
    resource_group_name = module.rg.name
    location            = module.rg.location

    enabled_for_deployment          = true
    enabled_for_disk_encryption     = true
    enabled_for_template_deployment = true

    network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = ["49.37.203.185"] #ip to remove
    virtual_network_subnet_ids = ["${data.azurerm_subnet.subnet.id}", "${data.azurerm_subnet.ops_subnet.id}"]
  }
}