terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
  }
}

module "transit_non_ha_azure" {
  source = "../.."

  cloud   = "azure"
  name    = "transit-non-ha-azure"
  region  = "West Europe"
  cidr    = "10.1.0.0/23"
  account = "Azure"
  ha_gw   = false
}

module "transit_ha_azure" {
  source = "../.."

  cloud   = "azure"
  name    = "transit-ha-azure"
  region  = "West Europe"
  cidr    = "10.2.0.0/23"
  account = "Azure"
}

resource "test_assertions" "cloud_type_non_ha" {
  component = "cloud_type_non_ha_azure"

  equal "cloud_type_non_ha" {
    description = "Module output is equal to check map."
    got         = module.transit_non_ha_azure.transit_gateway.cloud_type
    want        = 8
  }
}

resource "test_assertions" "cloud_type_ha" {
  component = "cloud_type_ha_azure"

  equal "cloud_type_ha" {
    description = "Module output is equal to check map."
    got         = module.transit_ha_azure.transit_gateway.cloud_type
    want        = 8
  }
}