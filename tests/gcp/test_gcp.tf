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

resource "test_assertions" "public_ip_non_ha" {
  component = "public_ip_non_ha_gcp"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_non_ha_gcp.transit_gateway.eip}/32"))
  }
}

resource "test_assertions" "public_ip_ha" {
  component = "public_ip_ha_gcp"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_gcp.transit_gateway.eip}/32"))
  }

  check "hagw_public_ip" {
    description = "HAGW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_gcp.transit_gateway.ha_eip}/32"))
  }
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
