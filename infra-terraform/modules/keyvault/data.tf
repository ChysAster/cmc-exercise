//// --- [Data (Existing resources)] --- ////

data "azurerm_client_config" "current" {}

data "azurerm_private_dns_zone" "pe_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "RG_Donnely.Defoort"
}