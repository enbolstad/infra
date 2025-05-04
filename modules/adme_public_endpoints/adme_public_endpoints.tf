resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azapi_resource" "adme" {
  type     = "Microsoft.OpenEnergyPlatform/energyServices@2023-02-21-preview"
  name     = "soprabp777"
  location = "northeurope"
  timeouts {
    create = "5h30m"
    update = "5h30m"
    delete = "5h30m"
  }
  tags = {
    Owner       = "OSDU Platform Team"
    Project     = "OSDU"
    Environment = "dev"
  }
  parent_id                 = azurerm_resource_group.default
  schema_validation_enabled = false
  body = {
    properties = {
      authAppId = var.authAppId
      dataPartitionNames = [
        {
          name = "preprod"
        }
      ]

      sku = {
        name = "Developer"
        tier = "Standard"
      }

      publicNetworkAccess = "Enabled"
    }
  }
}
