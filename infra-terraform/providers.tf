terraform {
  required_version = ">=0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.43.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
  backend "azurerm" {
    resource_group_name  = "RG_Donnely.Defoort"
    storage_account_name = "sttracshared"
    container_name       = "tfstate"
    key                  = "[FILL IN FULLNAME].tfstate"
  }
}

provider "azurerm" {
  use_oidc = true
  features {}
}

provider "azuread" {
  use_oidc = true
}
