terraform {
  backend "azurerm" {
    use_azuread_auth = true
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
  }
}
locals {
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

provider "azurerm" {
  subscription_id = local.subscription_id
  features {}
}

provider "azapi" {}



module "monitoring" {
  source                      = "git::https://ADV-SysDev@dev.azure.com/ADV-SysDev/Azure%20Governance/_git/-shared-tf-modules//azuremonitor"
  customer_name               = ""
  subscription_id             = local.subscription_id
  location                    = "northeurope"
  rg_name                     = ""
  rg_name_loganalytics        = ""
  loganalytics_workspace_name = ""
  managedidentity_name        = ""
  deploy_grafana              = false
}
