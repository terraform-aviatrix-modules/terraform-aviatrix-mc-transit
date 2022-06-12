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

module "transit_ha_oci_single_ad" {
  source = "../.."

  cloud   = "oci"
  name    = "transit-ha-oci-single-ad"
  region  = "eu-milan-1"
  cidr    = "10.3.0.0/23"
  account = "OCI"
}

resource "test_assertions" "public_ip_non_ha" {
  component = "public_ip_non_ha_oci"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_non_ha_oci.transit_gateway.eip}/32"))
  }
}

resource "test_assertions" "public_ip_ha" {
  component = "public_ip_ha_oci"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_oci.transit_gateway.eip}/32"))
  }

  check "hagw_public_ip" {
    description = "HAGW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_oci.transit_gateway.ha_eip}/32"))
  }
}

resource "test_assertions" "public_ip_ha_single_ad" {
  component = "public_ip_ha_oci_single_ad"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_oci_single_ad.transit_gateway.eip}/32"))
  }

  check "hagw_public_ip" {
    description = "HAGW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_oci_single_ad.transit_gateway.ha_eip}/32"))
  }
}

resource "test_assertions" "subnet_allocation_non_ha" {
  component = "subnet_allocation_non_ha_oci"

  equal "subnet_allocation_gw" {
    description = "Check GA is in correct subnet."
    got         = module.transit_non_ha_oci.transit_gateway.subnet
    want        = module.transit_non_ha_oci.vpc.public_subnets[3].cidr
  }

  equal "subnet_allocation_hagw" {
    description = "Check HAGW is in correct subnet."
    got         = module.transit_non_ha_oci.transit_gateway.ha_subnet
    want        = null
  }
}

resource "test_assertions" "subnet_allocation_ha" {
  component = "subnet_allocation_ha_oci"

  equal "subnet_allocation_gw" {
    description = "Check GA is in correct subnet."
    got         = module.transit_ha_oci.transit_gateway.subnet
    want        = module.transit_ha_oci.vpc.public_subnets[3].cidr
  }

  equal "subnet_allocation_hagw" {
    description = "Check HAGA is in correct subnet."
    got         = module.transit_ha_oci.transit_gateway.ha_subnet
    want        = module.transit_ha_oci.vpc.public_subnets[1].cidr
  }
}
