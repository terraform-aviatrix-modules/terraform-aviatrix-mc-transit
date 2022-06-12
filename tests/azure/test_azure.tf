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

resource "test_assertions" "public_ip_non_ha" {
  component = "public_ip_non_ha_azure"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_non_ha_azure.transit_gateway.eip}/32"))
  }
}

resource "test_assertions" "public_ip_ha" {
  component = "public_ip_ha_azure"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_azure.transit_gateway.eip}/32"))
  }

  check "hagw_public_ip" {
    description = "HAGW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_azure.transit_gateway.ha_eip}/32"))
  }
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

resource "test_assertions" "subnet_allocation_non_ha" {
  component = "subnet_allocation_non_ha_azure"

  equal "subnet_allocation_gw" {
    description = "Check GA is in correct subnet."
    got         = module.transit_non_ha_azure.transit_gateway.subnet
    want        = module.transit_non_ha_azure.vpc.public_subnets[2].cidr
  }

  equal "subnet_allocation_hagw" {
    description = "Check HAGW is in correct subnet."
    got         = module.transit_non_ha_azure.transit_gateway.ha_subnet
    want        = null
  }
}

resource "test_assertions" "subnet_allocation_ha" {
  component = "subnet_allocation_ha_azure"

  equal "subnet_allocation_gw" {
    description = "Check GA is in correct subnet."
    got         = module.transit_ha_azure.transit_gateway.subnet
    want        = module.transit_ha_azure.vpc.public_subnets[2].cidr
  }

  equal "subnet_allocation_hagw" {
    description = "Check HAGA is in correct subnet."
    got         = module.transit_ha_azure.transit_gateway.ha_subnet
    want        = module.transit_ha_azure.vpc.public_subnets[3].cidr
  }
}
