
//// --- [keyvault module] --- ////

resource "azurerm_key_vault" "key_vault" {
  name                          = var.name_keyvault
  location                      = var.location
  resource_group_name           = var.resource_group_name
  public_network_access_enabled = var.public_network_access_enabled
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 90
  sku_name                      = "standard"
  enable_rbac_authorization     = true
}

resource "azurerm_private_endpoint" "pe_kv" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.name_keyvault}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = "/subscriptions/cc934d76-6d72-49cb-a908-81217ad4ae29/resourceGroups/RG_Donnely.Defoort/providers/Microsoft.Network/virtualNetworks/vnet-trac-shared/subnets/snet-akv-weu-001"

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.pe_zone.id]
  }

  private_service_connection {
    name                           = "${var.name_keyvault}-pe"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    is_manual_connection           = false
    subresource_names              = ["Vault"]
  }
}

resource "azurerm_key_vault_secret" "add_secret" {
  name         = "webAppSecretValue"
  value        = var.webAppSecretValue
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on   = [azurerm_role_assignment.dynamic_role_assignment]
}

resource "azurerm_management_lock" "subscription-level" {
  count      = var.lock_resources ? 1 : 0
  name       = "kv-level"
  scope      = azurerm_key_vault.key_vault.id
  lock_level = "CanNotDelete"
  notes      = "keyvault can't be deleted!"
}

resource "azurerm_role_assignment" "dynamic_role_assignment" {
  for_each = { for idx, assignment in var.role_assignments : idx => assignment }

  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
