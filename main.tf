locals {
  subscription_id           = var.environment == "prod" ? var.subscription_id_prod : var.subscription_id_nonprod
  rg_name                   = format("rg-msa-app-adme-%s-we-001", var.environment)
  subscription_display_name = var.environment == "prod" ? var.subscription_display_name_prod : var.subscription_display_name_nonprod
  private_endpoints_name    = var.endpoints == "private" ? format("pe-msa-app-adme-%s-we-001", var.environment) : ""
  adme_vnet_name            = format("vnet-app-adme-%s-we-001", var.environment)
  adme_vnet_subnet_name     = format("snet-msa-app-adme-pep-%s-we-001", var.environment)
  law_name                  = format("law-msa-adme-mon-%s-we-001", var.environment)
  rg_name_osdu_service_log  = format("rg-msa-adme-mon-%s-we-001", var.environment)
  adme_name                 = var.environment == "prod" ? "soprabp85" : "soprabpdev76"
  adme_datapartition_name   = var.environment == "prod" ? "preprod" : "dev"
  log_sa_name               = var.environment == "prod" ? "soprbpadmepwe18" : "soprbpadmenpwe19"
  adme_sku                  = var.environment == "prod" ? "Developer" : "Developer"
  authAppId                 = var.environment == "prod" ? var.authAppId_prod : var.authAppId_nonprod
  tags                      = merge(var.tags, { environment = var.environment == "prod" ? "Prod" : "NonProd" })

}

module "adme_private_endpoints" {
  count                     = var.endpoints == "private" ? 1 : 0
  source                    = "./modules/adme_private_endpoints"
  subscription_id           = local.subscription_id
  subscription_display_name = local.subscription_display_name
  tenant_id                 = var.tenant_id
  rg_name                   = local.rg_name
  private_endpoints_name    = local.private_endpoints_name
  adme_vnet_name            = local.adme_vnet_name
  adme_vnet_subnet_name     = local.adme_vnet_subnet_name
  adme_name                 = local.adme_name
  adme_sku                  = local.adme_sku
  adme_datapartition_name   = local.adme_datapartition_name
  location                  = var.location
  authAppId                 = local.authAppId
  tags                      = local.tags
}

module "adme_public_endpoint" {
  count                     = var.endpoints == "public" ? 1 : 0
  source                    = "./modules/adme_public_endpoints"
  subscription_id           = local.subscription_id
  subscription_display_name = local.subscription_display_name
  tenant_id                 = var.tenant_id
  rg_name                   = local.rg_name
  adme_name                 = local.adme_name
  adme_sku                  = local.adme_sku
  adme_datapartition_name   = local.adme_datapartition_name
  location                  = var.location
  authAppId                 = local.authAppId
  tags                      = local.tags

}

#Storage and workspace for osdu service logs

resource "azurerm_resource_group" "osdu_service_log" {
  tags     = local.tags
  name     = local.rg_name_osdu_service_log
  location = var.location
}

resource "azurerm_storage_account" "adme_log" {
  tags                            = local.tags
  name                            = local.log_sa_name
  resource_group_name             = azurerm_resource_group.osdu_service_log.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
}


resource "azurerm_storage_container" "osdu_service_logs" {
  name                  = var.osdu_service_logs_container
  storage_account_id    = azurerm_storage_account.adme_log.id
  container_access_type = "private"
}

resource "azurerm_log_analytics_workspace" "osdu_service_logs" {
  tags                = local.tags
  name                = local.law_name
  location            = var.location
  resource_group_name = azurerm_resource_group.osdu_service_log.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
