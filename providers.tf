terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "2.0.1"
    }

  }
  backend "azurerm" {
    key              = "github.terraform.tfstate"
    use_oidc         = true
    use_azuread_auth = true
  }

}
provider "azurerm" {
  features {}
  use_oidc = true
}

provider "azapi" {
  tenant_id = var.tenant_id
}

