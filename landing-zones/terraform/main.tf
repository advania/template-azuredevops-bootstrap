locals {
  location                        = ""
  company_name                    = ""
  private_dns_resource_group_name = ""
  management_subscription_id      = ""
  connectivity_subscription_id    = ""
  identity_subscription_id        = ""
  platform_alz_library_ref        = "2025.02.0" #alz library ref : https://github.com/Azure/Azure-Landing-Zones-Library/tags
}





module "private_dns_zones" {
  source              = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version             = "~> 0.9"
  location            = local.location
  resource_group_name = local.private_dns_resource_group_name
}

module "alz" {
  source             = "Azure/avm-ptn-alz/azurerm"
  version            = "~> 0.11"
  architecture_name  = "alz"
  parent_resource_id = data.azapi_client_config.current.tenant_id
  location           = local.location
  subscription_placement = {

    management = {
      subscription_id       = local.management_subscription_id
      management_group_name = "management"
    }
    /*
    connectivity = {
      subscription_id       = local.connectivity_subscription_id
      management_group_name = "connectivity"
    }
    identity = {
      subscription_id       = local.identity_subscription_id
      management_group_name = "identity"
    }
    */
  }

  policy_default_values = {
    private_dns_zone_subscription_id     = jsonencode({ value = data.azapi_client_config.current.subscription_id })
    private_dns_zone_region              = jsonencode({ value = local.location })
    private_dns_zone_resource_group_name = jsonencode({ value = local.private_dns_resource_group_name })
  }
  dependencies = {
    policy_assignments = [
      module.private_dns_zones.private_dns_zone_resource_ids,
    ]
  }
  policy_assignments_to_modify = {
    landingzones = {

      policy_assignments = {
        Deny-Subnet-Without-Nsg = { enforcement_mode = "DoNotEnforce" }
        Deploy-VM-Backup        = { enforcement_mode = "DoNotEnforce" }
        Enable-DDoS-VNET        = { enforcement_mode = "DoNotEnforce" }
      }
      connectivity = {
        policy_assignments = {
          Enable-DDoS-VNET = { enforcement_mode = "DoNotEnforce" }

        }
      }
    }
  }
}


