//// --- [Outputs] --- ////

output "managed_identity" {
  value = local.managed_identity
}

output "keyvault" {
  value = local.keyvault
}

output "database" {
  value = local.database
}

output "app_service_plan" {
  value = local.app_service_plan
}

output "app_service" {
  value = local.webapp
}
