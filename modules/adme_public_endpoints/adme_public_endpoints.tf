resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azurerm_resource_group_template_deployment" "default" {
  name                = var.adme_name
  resource_group_name = azurerm_resource_group.default.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "name" = {
    value = "${var.adme_name}" }
    "location" = {
    value = "${var.location}" }
    "tagsByResource" = {
      value = var.tags
    }
    "authAppId" = {
      value = "${var.authAppId}"
    }
    "dataPartitionNames" = {
      value = [
        {
          "name" = "${var.adme_datapartition_name}"
        }
      ]
    }
    "cmkEnabled" = {
    value = false }
    "encryption" = {
    value = {} }
    "identity" = {
    value = {} }
    "corsRules" = {
    value = [] }
    "sku" = {
      value = {
        "name" = "${var.adme_sku}"
      }
    }
    "publicNetworkAccess" = {
    value = true }
    "privateEndpoints" = {
      value = []
    }
    "resourceGroupId" = {
    value = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}" }
  })

  template_content = file("template.json")
}

