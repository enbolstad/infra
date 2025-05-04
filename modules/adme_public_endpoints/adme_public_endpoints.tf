resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azapi_resource" "adme" {
  body = {
    properties = {
      authAppId = var.authAppId
      dataPartitionNames = [{
        name = "preprod"
        },
        {
          name = "preprod2"
      }]
    }
  }
  ignore_casing             = false
  ignore_missing_property   = true
  location                  = "northeurope"
  name                      = "soprabp777"
  parent_id                 = azurerm_resource_group.default.id
  schema_validation_enabled = true
  type                      = "Microsoft.OpenEnergyPlatform/energyServices@2022-04-04-preview"
  depends_on = [
    azurerm_resource_group.default
  ]
}
