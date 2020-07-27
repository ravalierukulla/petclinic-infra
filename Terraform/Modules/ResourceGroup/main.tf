
locals {
  mandatory_tags = {
    env = lower(var.Environment)
  }

  tags = merge(local.mandatory_tags, var.tags)
}

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
  tags     = local.tags
}