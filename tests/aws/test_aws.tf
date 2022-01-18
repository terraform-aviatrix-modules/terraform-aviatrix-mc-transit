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

module "non_ha" {
  source = "../.."

  cloud    = "aws"
  name     = "non-ha"
  region   = "eu-central-1"
  cidr     = "10.1.101.0/24"
  account  = "AWS"
  ha_gw    = false
}

module "ha" {
  source = "../.."

  cloud    = "aws"
  name     = "ha"
  region   = "eu-central-1"
  cidr     = "10.1.102.0/24"
  account  = "AWS"
}

resource "test_assertions" "cloud_type_non_ha" {
  component = "cloud_type_non_ha"

  equal "cloud_type_non_ha" {
    description = "Module output is equal to check map."
    got         = module.non_ha.transit_gateway.cloud_type
    want        = 1
  }
}

resource "test_assertions" "cloud_type_ha" {
  component = "cloud_type_ha"

  equal "cloud_type_ha" {
    description = "Module output is equal to check map."
    got         = module.ha.transit_gateway.cloud_type
    want        = 1
  }
}