//// --- [Generic Variables & Parameters] --- ////

variable "role_assignments" {
  type = list(object({
    principal_id         = string
    role_definition_name = string
  }))
}

variable "name_keyvault" {
  type        = string
  description = "Name of the keyvault that should be created."

}

variable "location" {
  type        = string
  description = "Location of the user assigned identity."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the user assigned identity should be deployed in."
}

variable "webAppSecretValue" {
  type        = string
  description = "secret value"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Is public network access enabled?"
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Create a private endpoint"
}

variable "lock_resources" {
  type        = bool
  description = "Lock the resources"
}
