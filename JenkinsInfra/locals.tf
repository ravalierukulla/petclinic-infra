locals {
    rg_name   = "${var.prefix}-${var.environment}-rg"
    vnet_name  = "${var.ntwkPrefix}-${var.environment}-vnet"
    subnet_name = "${var.prefix}-snt"
    network_rg_name = "${var.ntwkPrefix}-${var.environment}-rg"
    kv_name = "${var.prefix}-${var.environment}-kvt"
    build_vm = "${var.prefix}-${var.environment}-vm"
    tls_private_key = "${var.prefix}-tlskey"

 key_permissions         = ["get", "wrapkey", "unwrapkey"]
  secret_permissions      = ["get", "set", "list"]
  certificate_permissions = ["get", "create", "update", "list", "import"]
  storage_permissions     = ["get"]
    mandatory_tags = {
    Tier = "infra"
  }

  tags = merge(local.mandatory_tags, var.tags)

}