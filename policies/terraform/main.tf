terraform {
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "00000000-000000-0000000-000000-0000000"
  features {}
}

module "custom_policies" {
  source   = "git::https://github.com/advania/terraform-azurerm-azgov-policies?ref=main"
  location = "northeurope"
  #management_group_id         = "" # Management group ID default: "alz"
  #allowed_locations           = [""] # Regions we can use, list them in the following variable default: ["northeurope","westeurope"]
  #audit_tags                  = [""] # Immutable tags that are common to all resources, default: ["Owner","Project","Environment","CostCenter","BusinessImpact","Ticket"]
}

