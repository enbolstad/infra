resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azapi_resource" "adme" {
  type                      = "Microsoft.OpenEnergyPlatform/energyServices@2024-05-21"
  name                      = "datapartitiontestadme21"
  location                  = var.location
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
      dataPartitionNames = [{
        name = "dp1"
      }]
      sku = {
        name = "Developer"
        tier = "Standard"
      }

      publicNetworkAccess = "Enabled"
    }
  }
}
