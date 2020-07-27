data "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
}

locals {
  resource_location = var.location != "" ? var.location : data.azurerm_resource_group.rg.location

   mandatory_tags = {
    env = lower(var.Environment)
  }

  tags = merge(local.mandatory_tags, var.tags)
}
resource "azurerm_storage_account" "storage" {
  name                     = "${lower("${var.name}")}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = local.resource_location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  enable_blob_encryption    = var.enable_blob_encryption
  enable_file_encryption    = var.enable_file_encryption
  enable_https_traffic_only = var.enable_https_traffic_only
  is_hns_enabled            = var.is_hns_enabled
  enable_advanced_threat_protection = var.enable_advanced_threat_protection

  dynamic "network_rules" {
    for_each = length(concat(var.network_rules_ip_rules, var.network_rules_subnet_ids)) > 0 ? ["true"] : []
    content {
      ip_rules                   = var.network_rules_ip_rules
      virtual_network_subnet_ids = var.network_rules_subnet_ids
      default_action             = "Deny"
      bypass                     = var.bypass_services
    }
  }

  tags   = var.tags
}

resource "azurerm_storage_container" "storage" {
  count                 = "${length(var.containers)}"
  name                  = "${var.containers[count.index].name}"
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.storage.name}"
  container_access_type = var.containers[count.index].access_type
}