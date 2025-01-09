//// --- [Data (Existing resources)] --- ////

data "azurerm_mssql_server" "sql" {
  name                = "sql-trac-shared"
  resource_group_name = "RG_Donnely.Defoort"
}

data "azurerm_key_vault_secret" "secret" {
  name         = "sql-admin-password"
  key_vault_id = "/subscriptions/cc934d76-6d72-49cb-a908-81217ad4ae29/resourceGroups/RG_Donnely.Defoort/providers/Microsoft.KeyVault/vaults/kv-trac-shared"
}

data "azurerm_container_registry" "acr" {
  name                = "crtracshared"
  resource_group_name = "RG_Donnely.Defoort"
}
