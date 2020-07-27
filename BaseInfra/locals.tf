locals {
    rg_name   = "${var.rgPrefix}-${var.environment}-rg"
    vnet_name = "${var.ntwkPrefix}-${var.environment}-vnet"

    mandatory_tags = {
    Tier = "infra"
  }

  tags = merge(local.mandatory_tags, var.tags)

}



