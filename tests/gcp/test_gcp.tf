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

provider "aviatrix" {}

module "transit_non_ha_gcp" {
  source = "../.."

  cloud   = "gcp"
  name    = "transit-non-ha-gcp"
  region  = "us-east1"
  cidr    = "10.1.0.0/23"
  account = "GCP"
  ha_gw   = false
}

module "transit_ha_gcp" {
  source = "../.."

  cloud   = "gcp"
  name    = "transit-ha-gcp"
  region  = "us-east1"
  cidr    = "10.2.0.0/23"
  account = "GCP"
}

resource "test_assertions" "cloud_type_non_ha" {
  component = "cloud_type_non_ha_gcp"

  equal "cloud_type_non_ha" {
    description = ""
    got         = module.transit_non_ha_gcp.transit_gateway.cloud_type
    want        = 4
  }
}

resource "test_assertions" "cloud_type_ha" {
  component = "cloud_type_ha_gcp"

  equal "cloud_type_ha" {
    description = ""
    got         = module.transit_ha_gcp.transit_gateway.cloud_type
    want        = 4
  }
}
