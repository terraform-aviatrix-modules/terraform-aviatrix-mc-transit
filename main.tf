# Aviatrix Spoke VPC
resource "aviatrix_vpc" "default" {
  cloud_type           = local.cloud_type
  region               = local.cloud == "gcp" ? null : var.region
  cidr                 = local.cloud == "gcp" ? null : var.cidr
  account_name         = var.account
  name                 = local.name
  aviatrix_transit_vpc = contains(["aws", "ali"], local.cloud) ? true : false
  aviatrix_firenet_vpc = local.cloud == "azure" ? true : false
  resource_group       = var.resource_group

  dynamic "subnets" {
    for_each = local.cloud == "gcp" ? ["dummy"] : [] #Trick to make block conditional. Count not available on dynamic blocks.
    content {
      name   = local.name
      cidr   = var.cidr
      region = var.region
    }
  }

  dynamic "subnets" {
    for_each = length(var.ha_region) > 0 ? ["dummy"] : [] #Trick to make block conditional. Count not available on dynamic blocks.
    content {
      name   = "${local.name}-ha"
      cidr   = var.ha_cidr
      region = var.ha_region
    }
  }
}

#Transit GW
resource "aviatrix_transit_gateway" "default" {
  cloud_type                       = local.cloud_type
  vpc_reg                          = local.region
  gw_name                          = local.name
  gw_size                          = local.instance_size
  vpc_id                           = local.cloud == "oci" ? aviatrix_vpc.default.name : aviatrix_vpc.default.vpc_id
  account_name                     = var.account
  subnet                           = local.subnet
  zone                             = local.zone
  ha_subnet                        = var.ha_gw ? local.ha_subnet : null
  ha_gw_size                       = var.ha_gw ? local.instance_size : null
  ha_zone                          = var.ha_gw ? local.ha_zone : null
  connected_transit                = var.connected_transit
  enable_hybrid_connection         = var.hybrid_connection
  bgp_manual_spoke_advertise_cidrs = var.bgp_manual_spoke_advertise_cidrs
  enable_learned_cidrs_approval    = var.learned_cidr_approval
  learned_cidrs_approval_mode      = var.learned_cidrs_approval_mode
  enable_segmentation              = var.enable_segmentation
  insane_mode                      = var.insane_mode
  insane_mode_az                   = local.insane_mode_az
  ha_insane_mode_az                = var.ha_gw ? local.ha_insane_mode_az : null
  single_az_ha                     = var.single_az_ha
  single_ip_snat                   = var.single_ip_snat
  enable_advertise_transit_cidr    = var.enable_advertise_transit_cidr
  enable_firenet                   = var.enable_firenet
  enable_transit_firenet           = var.enable_transit_firenet
  enable_egress_transit_firenet    = var.enable_egress_transit_firenet
  bgp_polling_time                 = var.bgp_polling_time
  bgp_ecmp                         = var.bgp_ecmp
  local_as_number                  = var.local_as_number
  enable_bgp_over_lan              = var.enable_bgp_over_lan
  enable_encrypt_volume            = var.enable_encrypt_volume
  customer_managed_keys            = var.customer_managed_keys
  tunnel_detection_time            = var.tunnel_detection_time
  tags                             = var.tags
  availability_domain              = local.cloud == "oci" ? aviatrix_vpc.default.availability_domains[0] : null
  fault_domain                     = local.cloud == "oci" ? aviatrix_vpc.default.fault_domains[0] : null
  ha_availability_domain           = var.ha_gw ? (local.cloud == "oci" ? aviatrix_vpc.default.availability_domains[1] : null) : null
  ha_fault_domain                  = var.ha_gw ? (local.cloud == "oci" ? aviatrix_vpc.default.fault_domains[1] : null) : null
  enable_multi_tier_transit        = var.enable_multi_tier_transit
}
