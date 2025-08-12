terraform {
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }
  required_version = ">= 1.9, < 2.0"
  required_providers {
    alz = {
      source  = "Azure/alz"
      version = "~> 0.16"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0, >= 2.0.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "alz" {
  library_references = [
    {
      path = "platform/alz",
      ref  = local.platform_alz_library_ref
    }

  ]
}

provider "azurerm" {
  features {}
  subscription_id = local.management_subscription_id
}


data "azapi_client_config" "current" {}
