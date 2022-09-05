# Aviatrix Transit VPC
resource "aviatrix_vpc" "default" {
  cloud_type           = local.cloud_type
  region               = local.cloud == "gcp" ? null : var.region
  cidr                 = local.cloud == "gcp" ? null : var.cidr
  account_name         = var.account
  name                 = substr(local.name, 0, 30)
  aviatrix_transit_vpc = local.aviatrix_transit_vpc
  aviatrix_firenet_vpc = local.aviatrix_firenet_vpc
  resource_group       = var.resource_group
  private_mode_subnets = var.private_mode_subnets

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

# LAN VPC 
resource "aviatrix_vpc" "lan_vpc" {
  count                = local.cloud == "gcp" && var.enable_transit_firenet ? 1 : 0 #Only create for GCP and when firenet is enabled
  cloud_type           = 4
  account_name         = var.account
  name                 = "${local.name}-lan"
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false

  subnets {
    name   = "${local.name}-lan"
    cidr   = var.lan_cidr
    region = var.region
  }
}

#Transit GW
resource "aviatrix_transit_gateway" "default" {
  cloud_type                       = local.cloud_type
  vpc_reg                          = local.cloud == "gcp" ? local.zone : var.region
  gw_name                          = local.gw_name
  gw_size                          = local.instance_size
  vpc_id                           = aviatrix_vpc.default.vpc_id
  account_name                     = var.account
  subnet                           = local.subnet
  zone                             = local.cloud == "azure" ? local.zone : null
  ha_subnet                        = var.ha_gw ? local.ha_subnet : null
  ha_gw_size                       = var.ha_gw ? local.instance_size : null
  ha_zone                          = var.ha_gw ? local.ha_zone : null
  connected_transit                = var.enable_egress_transit_firenet ? false : var.connected_transit
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
  bgp_polling_time                 = var.bgp_polling_time
  bgp_ecmp                         = var.bgp_ecmp
  local_as_number                  = var.local_as_number
  enable_bgp_over_lan              = var.enable_bgp_over_lan
  enable_encrypt_volume            = var.enable_encrypt_volume
  customer_managed_keys            = var.customer_managed_keys
  tunnel_detection_time            = var.tunnel_detection_time
  tags                             = var.tags
  availability_domain              = local.availability_domain
  fault_domain                     = local.fault_domain
  ha_availability_domain           = local.ha_availability_domain
  ha_fault_domain                  = local.ha_fault_domain
  enable_multi_tier_transit        = var.enable_multi_tier_transit
  enable_active_standby            = var.enable_active_standby
  enable_active_standby_preemptive = var.enable_active_standby_preemptive
  enable_s2c_rx_balancing          = var.enable_s2c_rx_balancing
  rx_queue_size                    = var.rx_queue_size
  enable_preserve_as_path          = var.enable_preserve_as_path
  enable_gateway_load_balancer     = var.enable_gateway_load_balancer
  bgp_lan_interfaces_count         = var.bgp_lan_interfaces_count

  #Custom EIP settings
  allocate_new_eip                 = var.allocate_new_eip
  eip                              = var.eip
  ha_eip                           = var.ha_eip
  azure_eip_name_resource_group    = var.azure_eip_name_resource_group
  ha_azure_eip_name_resource_group = var.ha_azure_eip_name_resource_group

  #Private mode settings
  private_mode_lb_vpc_id      = var.private_mode_lb_vpc_id
  private_mode_subnet_zone    = var.private_mode_subnets && local.cloud == "aws" ? format("%s%s", var.region, local.az1) : null
  ha_private_mode_subnet_zone = var.private_mode_subnets && local.cloud == "aws" && var.ha_gw ? format("%s%s", var.region, local.az2) : null

  #Firenet Settings
  enable_firenet                = var.enable_firenet
  enable_transit_firenet        = local.enable_transit_firenet
  enable_egress_transit_firenet = var.enable_egress_transit_firenet

  #GCP Firenet settings
  lan_vpc_id         = var.enable_transit_firenet && local.cloud == "gcp" ? aviatrix_vpc.lan_vpc[0].name : null
  lan_private_subnet = var.enable_transit_firenet && local.cloud == "gcp" ? aviatrix_vpc.lan_vpc[0].subnets[0].cidr : null

  dynamic "bgp_lan_interfaces" {
    for_each = var.bgp_lan_interfaces
    content {
      vpc_id = bgp_lan_interfaces.value.vpc_id
      subnet = bgp_lan_interfaces.value.subnet
    }
  }

  dynamic "ha_bgp_lan_interfaces" {
    for_each = var.ha_bgp_lan_interfaces
    content {
      vpc_id = ha_bgp_lan_interfaces.value.vpc_id
      subnet = ha_bgp_lan_interfaces.value.subnet
    }
  }
}
