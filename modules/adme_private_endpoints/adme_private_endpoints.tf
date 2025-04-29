resource "azurerm_resource_group" "default" {
  tags     = var.tags
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "adme" {
  tags                = var.tags
  name                = var.adme_vnet_name
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "adme" {
  name                 = var.adme_vnet_subnet_name
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.adme.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "random_id" "private_link_service_connection_id" {
  byte_length = 16
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
    value = false }
    "privateEndpoints" = {
      value = [{
        "subscription" : {
          "authorizationSource" : "RoleBased",
          "displayName" : "${var.subscription_display_name}",
          "state" : "Enabled",
          "subscriptionId" : "${var.subscription_id}",
          "subscriptionPolicies" : {},
          "tenantId" : "${var.tenant_id}",
          "promotions" : [],
          "uniqueDisplayName" : "${var.subscription_display_name}"
        },
        "location" : {
          "id" : "/subscriptions/${var.subscription_id}/locations/${var.location}",
          "name" : "${var.location}",
          "metadata" : {}
        },
        "resourceGroup" : {
          "mode" : 0,
          "value" : {
            "name" : "${var.rg_name}",
            "location" : "${var.location}",
            "provisioningState" : "Succeeded"
          }
        },
        "privateEndpoint" : {
          "id" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}/providers/Microsoft.Network/privateEndpoints/${var.private_endpoints_name}",
          "name" : "${var.private_endpoints_name}",
          "location" : "${var.location}",
          "properties" : {
            "privateLinkServiceConnections" : [
              {
                "id" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}/providers/Microsoft.Network/privateEndpoints/privateLinkServiceConnections/${var.private_endpoints_name}_${random_id.private_link_service_connection_id.hex}",
                "name" : "${var.private_endpoints_name}_${random_id.private_link_service_connection_id.hex}",
                "properties" : {
                  "privateLinkServiceId" : "/subscriptions/steps('basics').resourceScope.subscription.id/resourceGroups/steps('basics').resourceScope.resourceGroup.id/providers/Microsoft.OpenEnergyPlatform/energyServices",
                  "groupIds" : [
                    "Azure Data Manager for Energy"
                  ]
                }
              }
            ],
            "manualPrivateLinkServiceConnections" : [],
            "subnet" : {
              "id" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}/providers/Microsoft.Network/virtualNetworks/${var.adme_vnet_name}/subnets/${var.adme_vnet_subnet_name}"
            }
          },
          "type" : "Microsoft.Network/privateEndpoints",
          "tags" : {}
        },
        "subResource" : {
          "groupId" : "Azure Data Manager for Energy",
          "expectedPrivateDnsZoneName" : "[privatelink.energy.azure.com,privatelink.blob.core.windows.net]",
          "subResourceDisplayName" : "Azure Data Manager for Energy"
        }
      }]
    }
    "resourceGroupId" = {
    value = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}" }
  })

  template_content = file("template.json")
  depends_on = [
    azurerm_subnet.adme,
  ]

}

resource "null_resource" "delete_template_resources" {
  depends_on = [azurerm_resource_group_template_deployment.default]
  triggers = {
    deployment_name                 = azurerm_resource_group_template_deployment.default.name
    resource_group                  = azurerm_resource_group.default.name
    adme_name                       = var.adme_name
    private_endpoints_name          = var.private_endpoints_name
    private_link_service_connection = random_id.private_link_service_connection_id.hex
    dns_zone_energy                 = "privatelink.energy.azure.com"
    dns_zone_blob                   = "privatelink.blob.core.windows.net"
    subscription_id                 = var.subscription_id
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT

      # Delete the specific private endpoint
      echo "Deleting private endpoint: ${self.triggers.private_endpoints_name} in resource group: ${self.triggers.resource_group}"
      az network private-endpoint delete --name "${self.triggers.private_endpoints_name}" --resource-group "${self.triggers.resource_group}" || echo "Failed to delete private endpoint: ${self.triggers.private_endpoints_name}"

      # Delete the resource associated with var.adme_name
      echo "Deleting resource: ${self.triggers.adme_name}"
      az resource delete --ids "/subscriptions/${self.triggers.subscription_id}/resourceGroups/${self.triggers.resource_group}/providers/Microsoft.OpenEnergyPlatform/energyServices/${self.triggers.adme_name}" || echo "Failed to delete resource: ${self.triggers.adme_name}"

    # Delete private DNS zones and links
      for zone in "${self.triggers.dns_zone_energy}" "${self.triggers.dns_zone_blob}"; do
        echo "Deleting private DNS links and zone: $zone"
        LINKS=$(az network private-dns link vnet list --resource-group "${self.triggers.resource_group}" --zone-name "$zone" --query "[].name" -o tsv || true)
        if [ -n "$LINKS" ]; then
          for link in $LINKS; do
            echo "Deleting private DNS link: $link"
            az network private-dns link vnet delete --name $link --resource-group "${self.triggers.resource_group}" --zone-name "$zone" --yes || echo "Failed to delete private DNS link: $link"
          done
        else
          echo "No private DNS links found for zone: $zone"
        fi
        az network private-dns zone delete --name "$zone" --resource-group "${self.triggers.resource_group}" --yes || echo "Failed to delete private DNS zone: $zone"
      done

      # Delete the template deployment
      echo "Deleting template deployment: ${self.triggers.deployment_name}"
      az deployment group delete --name "${self.triggers.deployment_name}" --resource-group "${self.triggers.resource_group}" || echo "Failed to delete template deployment: ${self.triggers.deployment_name}"

    EOT
  }
}
