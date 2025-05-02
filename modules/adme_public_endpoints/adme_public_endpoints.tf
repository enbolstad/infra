resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azapi_resource" "adme" {
  type                      = "Microsoft.OpenEnergyPlatform/energyServices@2023-02-21-preview"
  name                      = var.adme_name
  location                  = var.location
  parent_id                 = azurerm_resource_group.default.id
  schema_validation_enabled = false
  timeouts {
    create = "5h30m"
    update = "5h30m"
    delete = "5h30m"
  }

  body = {
    properties = {
      authAppId = var.authAppId
      dataPartitionNames = [
        {
          name = var.adme_datapartition_name
        }
      ]
      sku = {
        name = var.adme_sku
        tier = "Standard"
      }

      publicNetworkAccess = "Enabled"
    }
  }
}
