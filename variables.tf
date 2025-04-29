variable "environment" {
  description = "Environment to create the ADME resources in, either nonprod or prod"
  type        = string

  validation {
    condition     = contains(["nonprod", "prod"], var.environment)
    error_message = "Environment must be nonprod or prod"
  }
}


variable "endpoints" {
  description = "Choose between public and private endpoints, valid values are public or private"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.endpoints)
    error_message = "Endpoints must be public or private"
  }
}

variable "subscription_id_prod" {
  description = "The prod subscription ID"
  type        = string
  default     = "538f8f82-ce85-4586-b455-60a5ae312e50"
}

variable "subscription_id_nonprod" {
  description = "The nonprod subscription ID"
  type        = string
  default     = "423c4ba2-3435-4b00-a4a9-e16a16c94e77"

}

variable "subscription_display_name_nonprod" {
  description = "The display name of the nonprod subscription"
  type        = string
  default     = "ADME-NonProd"

}

variable "subscription_display_name_prod" {
  description = "The display name of the prod subscription"
  type        = string
  default     = "ADME-Prod"

}

variable "tenant_id" {
  description = "The Id of entraID tenant"
  type        = string
  default     = "3b7e4170-8348-4aa4-bfae-06a3e1867469"

}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "westeurope"

}

variable "authAppId_prod" {
  description = "The auth app id"
  type        = string
  default     = "b5985dfe-4952-493b-ad5a-77dbc9942648"

}
variable "authAppId_nonprod" {
  description = "The auth app id"
  type        = string
  default     = "eb356ce6-96ed-4e75-aad2-ebf22280af51"

}


variable "adme_sku" {
  description = "The sku of the adme instance"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Developer", "Standard"], var.adme_sku)
    error_message = "The sku must be either 'Developer' or 'Standard'."
  }
}

variable "osdu_service_logs_container" {
  description = "The name of the container for the osdu service logs"
  type        = string
  default     = "osduservicelogs"

}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default = {
    deployment_type  = "IaC"
    managed_by       = "stian.holm@akerbp.com"
    owned_by         = "stian.holm@akerbp.com"
    repository       = "https://github.com/AkerBP/akerbp-adme-infra"
    business_unit    = "Drilling & Wells"
    cost_center      = "ONSDRW"
    project          = "ADME"
    change_number    = "RITM0135393"
    #business_service = ""
    #creator          = ""
    #service_provider = ""
  }
}
