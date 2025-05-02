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

  required_version = ">=0.12"
}
provider "azurerm" {
  features {}
}
provider "azapi" {
  use_oidc = true

}

