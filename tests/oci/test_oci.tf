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

module "transit_non_ha_oci" {
  source = "../.."

  cloud   = "oci"
  name    = "transit-non-ha-oci"
  region  = "us-ashburn-1"
  cidr    = "10.1.0.0/23"
  account = "OCI"
  ha_gw   = false
}

module "transit_ha_oci" {
  source = "../.."

  cloud   = "oci"
  name    = "transit-ha-oci"
  region  = "us-ashburn-1"
  cidr    = "10.2.0.0/23"
  account = "OCI"
}

resource "test_assertions" "public_ip_non_ha" {
  component = "public_ip_non_ha"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_non_ha_oci.transit_gateway.eip}/32"))
  }
}

resource "test_assertions" "public_ip_ha" {
  component = "public_ip_ha"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_oci.transit_gateway.eip}/32"))
  }

  check "hagw_public_ip" {
    description = "HAGW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_oci.transit_gateway.ha_eip}/32"))
  }
}

