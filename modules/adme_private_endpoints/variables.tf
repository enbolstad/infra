variable "rg_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subscription_id" {
  description = "The subscription id"
  type        = string

}

variable "location" {
  description = "The location of the resource group"
  type        = string

}

variable "authAppId" {
  description = "The auth app id"
  type        = string

}

variable "adme_name" {
  description = "The name of the adme instance"
  type        = string

}

variable "tenant_id" {
  description = "The Id of entraID tenant"
  type        = string

}

variable "subscription_display_name" {
  description = "The display name of the subscription"
  type        = string
}

variable "private_endpoints_name" {
  description = "The display name of the Private Endpoint"
  type        = string

}

variable "adme_vnet_name" {
  description = "Name of the vnet where the Private Endpoint will be created"
  type        = string
}

variable "adme_vnet_subnet_name" {
  description = "Name of the subnet where the Private Endpoint will be created"
  type        = string
}

variable "adme_datapartition_name" {
  description = "Name of the data partition"
  type        = string
}

variable "adme_sku" {
  description = "The sku of the adme instance"
  type        = string

  validation {
    condition     = contains(["Developer", "Standard"], var.adme_sku)
    error_message = "The sku must be either 'Developer' or 'Standard'."
  }

}
variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}