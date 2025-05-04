resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azapi_resource" "adme" {
  type                      = "Microsoft.OpenEnergyPlatform/energyServices@2023-02-21-preview"
  name                      = "soprabp777"
  location                  = "northeurope"
  ignore_missing_property   = true
  schema_validation_enabled = false

  timeouts {
    create = "5h30m"
    update = "5h30m"
    delete = "5h30m"
  }

  parent_id = azurerm_resource_group.default.id

  body = {
    properties = {
      authAppId = var.authAppId
      dataPartitionNames = [
        {
          name = "preprod"
        },
        {
          name = "preprod2"
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
