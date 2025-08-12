terraform {
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }
  required_providers {
    azapi = {
      source  = "hashicorp/azapi"
      version = "~> 2.0"
    }
  }
}

provider "azapi" {
  features {}
}

module "monitoring" {
  source = "git::https://github.com/advania/terraform-azapi-azgov-networking?ref=main"

}
