locals {
    rg_name   = "${var.prefix}-${var.environment}-rg"
    vnet_name  = "${var.ntwkPrefix}-${var.environment}-vnet"
    app_subnet_name = "${var.prefix}-snt"
    network_rg_name = "${var.ntwkPrefix}-${var.environment}-rg"
    app_kv_name = "${var.prefix}-${var.environment}-kvt"
    app_vm = "${var.prefix}-${var.environment}-vm"
    tls_private_key = "${var.prefix}-tlskey"

    ops_subnet_name = "${var.opsPrefix}-snt"
    ops_rg_name = "${var.opsPrefix}-${var.environment}-rg"


  key_permissions         = ["get", "wrapkey", "unwrapkey"]
  secret_permissions      = ["get", "set", "list"]
  certificate_permissions = ["get", "create", "update", "list", "import"]
  storage_permissions     = ["get"]

    mandatory_tags = {
    Tier = "app"
  }

  tags = merge(local.mandatory_tags, var.tags)

}