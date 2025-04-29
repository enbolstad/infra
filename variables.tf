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
  default     = "464c8a03-5870-4a25-94f6-69cc795997ed"
}

variable "subscription_id_nonprod" {
  description = "The nonprod subscription ID"
  type        = string
  default     = "0"

}

variable "subscription_display_name_nonprod" {
  description = "The display name of the nonprod subscription"
  type        = string
  default     = "0"

}

variable "subscription_display_name_prod" {
  description = "The display name of the prod subscription"
  type        = string
  default     = "Microsoft Azure-sponsing"

}

variable "tenant_id" {
  description = "The Id of entraID tenant"
  type        = string
  default     = "8b87af7d-8647-4dc7-8df4-5f69a2011bb5"

}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "northeurope"

}

variable "authAppId_prod" {
  description = "The auth app id"
  type        = string
  default     = "f37be710-de99-4d1d-bc62-8f5cde53d030"

}
variable "authAppId_nonprod" {
  description = "The auth app id"
  type        = string
  default     = "0"

}


variable "adme_sku" {
  description = "The sku of the adme instance"
  type        = string
  default     = "Developer"

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
