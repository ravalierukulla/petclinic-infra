data "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
}

locals {
  resource_location = var.location != "" ? var.location : data.azurerm_resource_group.rg.location

 default_network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = []
  }
  disable_network_acls = {
    bypass                     = "None"
    default_action             = "Allow"
    ip_rules                   = null
    virtual_network_subnet_ids = null
  }

  merged_network_acls = var.network_acls != null ? merge(local.default_network_acls, var.network_acls) : null

   mandatory_tags = {
    env = lower(var.Environment)
  }

  tags = merge(local.mandatory_tags, var.tags)
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = local.resource_location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  sku_name = var.sku_name

  dynamic "network_acls" {
    for_each = local.merged_network_acls == null ? [local.disable_network_acls] : [local.merged_network_acls]
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = local.tags
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault_access_policy.kv_access_policy]
}