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

module "transit_non_ha_aws" {
  source = "../.."

  cloud   = "aws"
  name    = "transit-non-ha-aws"
  region  = "eu-central-1"
  cidr    = "10.1.0.0/23"
  account = "AWS"
  ha_gw   = false
}

module "transit_ha_aws" {
  source = "../.."

  cloud   = "aws"
  name    = "transit-ha-aws"
  region  = "eu-central-1"
  cidr    = "10.2.0.0/23"
  account = "AWS"
}

module "transit_non_ha_aws_insane_mode" {
  source = "../.."

  cloud       = "aws"
  name        = "transit-non-ha-aws"
  region      = "eu-central-1"
  cidr        = "10.3.0.0/23"
  account     = "AWS"
  ha_gw       = false
  insane_mode = true
}

resource "test_assertions" "public_ip_non_ha" {
  component = "public_ip_non_ha_aws"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_non_ha_aws.transit_gateway.eip}/32"))
  }
}

resource "test_assertions" "public_ip_ha" {
  component = "public_ip_ha_aws"

  check "gw_public_ip" {
    description = "GW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_aws.transit_gateway.eip}/32"))
  }

  check "hagw_public_ip" {
    description = "HAGW has public IP"
    condition   = can(cidrnetmask("${module.transit_ha_aws.transit_gateway.ha_eip}/32"))
  }
}

resource "test_assertions" "cloud_type_non_ha" {
  component = "cloud_type_non_ha_aws"

  equal "cloud_type_non_ha" {
    description = "Module output is equal to check map."
    got         = module.transit_non_ha_aws.transit_gateway.cloud_type
    want        = 1
  }
}

resource "test_assertions" "cloud_type_ha" {
  component = "cloud_type_ha_aws"

  equal "cloud_type_ha" {
    description = "Module output is equal to check map."
    got         = module.transit_ha_aws.transit_gateway.cloud_type
    want        = 1
  }
}

resource "test_assertions" "subnet_allocation_non_ha" {
  component = "subnet_allocation_non_ha_aws"

  equal "subnet_allocation_gw" {
    description = "Check GA is in correct subnet."
    got         = module.transit_non_ha_aws.transit_gateway.subnet
    want        = module.transit_non_ha_aws.vpc.public_subnets[0].cidr
  }

  equal "subnet_allocation_hagw" {
    description = "Check HAGW is in correct subnet."
    got         = module.transit_non_ha_aws.transit_gateway.ha_subnet
    want        = null
  }
}

resource "test_assertions" "subnet_allocation_ha" {
  component = "subnet_allocation_ha_aws"

  equal "subnet_allocation_gw" {
    description = "Check GW is in correct subnet."
    got         = module.transit_ha_aws.transit_gateway.subnet
    want        = module.transit_ha_aws.vpc.public_subnets[0].cidr
  }

  equal "subnet_allocation_hagw" {
    description = "Check HAGW is in correct subnet."
    got         = module.transit_ha_aws.transit_gateway.ha_subnet
    want        = module.transit_ha_aws.vpc.public_subnets[2].cidr
  }
}

resource "test_assertions" "instance_size" {
  component = "instance_size"

  equal "instance_size_gw" {
    description = "Check GW has correct instance size."
    got         = module.transit_ha_aws.transit_gateway.gw_size
    want        = "t3.medium"
  }

  equal "instance_size_hagw" {
    description = "Check HAGA has correct instance size."
    got         = module.transit_ha_aws.transit_gateway.ha_gw_size
    want        = "t3.medium"
  }

  equal "instance_size_gw_non_ha" {
    description = "Check GW has correct instance size."
    got         = module.transit_non_ha_aws_insane_mode.transit_gateway.gw_size
    want        = "c5n.xlarge"
  }
}
