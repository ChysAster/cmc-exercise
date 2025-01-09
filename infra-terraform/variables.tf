//// --- [Generic Variables] --- ////

variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "[FILL IN RG NAME]"
}

variable "location" {
  description = "Location"
  default     = "westeurope"
}

variable "bootcamp_starters_object_id" {
  description = "Bootcamp AD group object ID"
  default     = "59d3453a-636c-47d0-b294-1b56eaab59fb"
}

variable "service_connection_object_id" {
  description = "Service connection object ID"
  default     = "161220a4-9f07-42b8-80cb-14fe91328ed7"
}

variable "lockResources" {
  description = "Boolean which will set a resource in locked state."
  default     = false
}

variable "DOCKER_REGISTRY_SERVER_URL" {
  description = "DOCKER REGISTRY URL FOR PULLING IMAGE"
}

variable "DOCKER_REGISTRY_SERVER_PASSWORD" {
  description = "DOCKER PASSWORD FOR PULLING IMAGE"
}

variable "DOCKER_REGISTRY_SERVER_USERNAME" {
  description = "DOCKER USERNAME FOR PULLING IMAGE "
}
