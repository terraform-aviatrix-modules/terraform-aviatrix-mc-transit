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

module "transit_non_ha_ali" {
  source = "../.."

  cloud   = "ali"
  name    = "transit-non-ha-ali"
  region  = "acs-eu-central-1 (Frankfurt)"
  cidr    = "10.1.0.0/23"
  account = "ALI"
  ha_gw   = false
}

module "transit_ha_ali" {
  source = "../.."

  cloud   = "ali"
  name    = "transit-ha-ali"
  region  = "acs-eu-central-1 (Frankfurt)"
  cidr    = "10.2.0.0/23"
  account = "ALI"
}

resource "test_assertions" "cloud_type_non_ha" {
  component = "cloud_type_non_ha_ali"

  equal "cloud_type_non_ha" {
    description = ""
    got         = module.transit_non_ha_ali.transit_gateway.cloud_type
    want        = 8192
  }
}

resource "test_assertions" "cloud_type_ha" {
  component = "cloud_type_ha_ali"

  equal "cloud_type_ha" {
    description = ""
    got         = module.transit_ha_ali.transit_gateway.cloud_type
    want        = 8192
  }
}