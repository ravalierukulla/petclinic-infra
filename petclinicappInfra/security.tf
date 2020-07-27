resource "azurerm_user_assigned_identity" "vm" {
  location              = module.rg.location
  resource_group_name   = module.rg.name

  name = "${module.rg.name}-${local.app_vm}-uai"
}

resource "tls_private_key" "vm" {
  algorithm   = "RSA"
  ecdsa_curve = "4096"
}
data "azurerm_client_config" "current" {}

# Need to push private key to keyvault

# -
# - Store Generated Private SSH Key to Key Vault Secrets
# - Design Decision #1582
# -
resource "azurerm_key_vault_secret" "privatekey" {
  name         = local.tls_private_key
  value        = tls_private_key.vm.private_key_pem
  key_vault_id = module.KV.id
  depends_on = [
    azurerm_key_vault_access_policy.this
  ]
}


resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = module.KV.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.vm.principal_id

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

}

data "azurerm_role_definition" "owner" {
  name = "Owner"
}

data "azurerm_resource_group" "rgdata"{
    name = module.rg.name
}
# Grant the VM identity owner rights to the current subscription
resource "azurerm_role_assignment" "owner_current_resorce_group" {
  scope              = data.azurerm_resource_group.rgdata.id
  role_definition_id = "${data.azurerm_resource_group.rgdata.id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azurerm_user_assigned_identity.vm.principal_id
}


