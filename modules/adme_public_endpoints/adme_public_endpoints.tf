resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azapi_resource" "adme" {
  body = {
    properties = {
      authAppId = "f37be710-de99-4d1d-bc62-8f5cde53d030"
      dataPartitionNames = [{
        name = "preprod"
        }, {
        name = "dp3"
        }, {
        name = "dp4"
      }]
    }
  }
  ignore_casing             = false
  ignore_missing_property   = true
  location                  = "northeurope"
  name                      = "soprabp85"
  parent_id                 = "/subscriptions/464c8a03-5870-4a25-94f6-69cc795997ed/resourceGroups/rg-msa-app-adme-prod-we-001"
  schema_validation_enabled = true
  type                      = "Microsoft.OpenEnergyPlatform/energyServices@2022-04-04-preview"
  depends_on = [
    azurerm_resource_group.default
  ]
}
