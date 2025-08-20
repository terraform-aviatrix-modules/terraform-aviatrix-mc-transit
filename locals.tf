locals {
  cloud                 = lower(var.cloud)
  name                  = coalesce(var.name, local.default_name)
  gw_name               = coalesce(var.gw_name, local.name)
  suffix                = var.enable_egress_transit_firenet ? "-egress" : "-transit"
  region_name           = lower(replace(trim(split("(", var.region)[0], " "), " ", "-")) # Remove everything after "(" (Alibaba), trim whitespace and replace spaces with dashes. Force lowercase.
  default_name          = format("avx-%s%s", local.region_name, local.suffix)
  cidr                  = var.use_existing_vpc ? "10.0.0.0/20" : var.cidr #Set dummy if existing VPC is used.
  cidrbits              = tonumber(split("/", local.cidr)[1])
  newbits               = 26 - local.cidrbits
  netnum                = pow(2, local.newbits)
  insane_mode_subnet    = var.insane_mode || var.private_mode_subnets ? cidrsubnet(local.cidr, local.newbits, local.netnum - 2) : null
  ha_insane_mode_subnet = var.insane_mode || var.private_mode_subnets ? cidrsubnet(local.cidr, local.newbits, local.netnum - 1) : null

  # Auto disable AZ support for Gov, DOD and China regions in Azure
  az_support = local.is_gov || local.is_china ? false : var.az_support

  az1 = length(var.az1) > 0 ? var.az1 : lookup(local.az1_map, local.cloud, null)
  az1_map = {
    azure = local.az_support ? "az-1" : null,
    aws   = "a",
    gcp   = "b",
  }

  az2 = length(var.az2) > 0 ? var.az2 : lookup(local.az2_map, local.cloud, null)
  az2_map = {
    azure = local.az_support ? "az-2" : null,
    aws   = "b",
    gcp   = "c",
  }

  subnet = (var.use_existing_vpc ?
    var.gw_subnet
    : (
      (var.insane_mode && contains(["aws", "azure", "oci"], local.cloud)) || (var.private_mode_subnets && contains(["aws", "azure"], local.cloud)) ?
      local.insane_mode_subnet
      :
      (local.cloud == "gcp" ?
        aviatrix_vpc.default[0].subnets[local.subnet_map[local.cloud]].cidr
        :
        aviatrix_vpc.default[0].public_subnets[local.subnet_map[local.cloud]].cidr
      )
    )
  )

  subnet_map = {
    azure = 2,
    aws   = 0
    gcp   = 0,
    oci   = 3,
    ali   = 0,
  }

  ha_subnet = (var.use_existing_vpc ?
    var.hagw_subnet :
    (
      (var.insane_mode && contains(["aws", "azure", "oci"], local.cloud)) || (var.private_mode_subnets && contains(["aws", "azure"], local.cloud)) ?
      local.ha_insane_mode_subnet
      :
      (local.cloud == "gcp" ?
        aviatrix_vpc.default[0].subnets[local.ha_subnet_map[local.cloud]].cidr
        :
        (local.single_az_mode ?
          local.subnet
          :
          aviatrix_vpc.default[0].public_subnets[local.ha_subnet_map[local.cloud]].cidr
        )
      )
    )
  )

  ha_subnet_map = {
    azure = 3,
    aws   = 2
    gcp   = length(var.ha_region) > 0 ? 1 : 0
    oci   = 1,
    ali   = 1,
  }

  zone = lookup(local.zone_map, local.cloud, null)
  zone_map = {
    azure = local.az1,
    gcp   = local.cloud == "gcp" ? "${var.region}-${local.az1}" : null
  }

  ha_zone = lookup(local.ha_zone_map, local.cloud, null)
  ha_zone_map = {
    azure = local.az2,
    gcp   = local.cloud == "gcp" ? "${coalesce(var.ha_region, var.region)}-${local.az2}" : null
  }

  insane_mode_az = var.insane_mode ? lookup(local.insane_mode_az_map, local.cloud, null) : null
  insane_mode_az_map = {
    aws = local.cloud == "aws" ? "${var.region}${local.az1}" : null,
  }

  ha_insane_mode_az = var.insane_mode ? lookup(local.ha_insane_mode_az_map, local.cloud, null) : null
  ha_insane_mode_az_map = {
    aws = local.cloud == "aws" ? "${var.region}${local.az2}" : null,
  }

  #Determine cloud_type
  is_china    = can(regex("^cn-|^china ", lower(var.region))) && contains(["aws", "azure"], local.cloud)            #If a region in Azure or AWS starts with China prefix, then results in true.
  is_gov      = can(regex("^us-gov|^usgov |^usdod ", lower(var.region))) && contains(["aws", "azure"], local.cloud) #If a region in Azure or AWS starts with Gov/DoD prefix, then results in true.
  check_china = local.is_china ? lookup(local.cloud_type_map_china, local.cloud, null) : null                       #Returns cloud type only if is_china is true, else null
  check_gov   = local.is_gov ? lookup(local.cloud_type_map_gov, local.cloud, null) : null                           #Returns cloud type only if is_gov is true, else null
  cloud_type  = coalesce(local.check_china, local.check_gov, lookup(local.cloud_type_map, local.cloud, null))       #Takes first found value

  cloud_type_map = {
    azure = 8,
    aws   = 1,
    gcp   = 4,
    oci   = 16,
    ali   = 8192,
  }

  cloud_type_map_china = {
    azure = 2048,
    aws   = 1024,
  }

  cloud_type_map_gov = {
    azure = 32,
    aws   = 256,
  }

  instance_size = (
    coalesce(var.instance_size, (
      var.insane_mode || local.enable_transit_firenet ?
      lookup(local.insane_mode_instance_size_map, local.cloud, null) #If instance size is not provided and var.insane_mode or local.enable_transit_firenet is true, lookup in this table.
      :                                                              #
      lookup(local.instance_size_map, local.cloud, null)             #If instance size is not provided and var.insane_mode and local.enable_transit_firenet are false, lookup in this table.
      )
    )
  )

  instance_size_map = {
    azure = "Standard_B1ms",
    aws   = "t3.medium",
    gcp   = "n1-standard-1",
    oci   = "VM.Standard2.2",
    ali   = "ecs.g5ne.large",
  }

  insane_mode_instance_size_map = {
    azure = "Standard_D3_v2",
    aws   = "c5n.xlarge",
    gcp   = "n1-highcpu-4",
    oci   = "VM.Standard2.4",
    ali   = null
  }

  #Single AZ mode is not related to HA. It is meant for corner case scenario's where customers want to deploy the entire firenet in 1 AZ for traffic cost saving.
  single_az_mode = (
    local.az1 == local.az2                          #Trigger only if az1 and az2 are set to the same value
    && contains(["aws", "azure"], lower(var.cloud)) #And it is in Azure or AWS.
    && local.az1 != null                            #And the AZ has not been nulled.
  )

  #Determine OCI Availability domains
  default_availability_domain    = local.cloud == "oci" ? aviatrix_vpc.default[0].availability_domains[0] : null
  default_fault_domain           = local.cloud == "oci" ? aviatrix_vpc.default[0].fault_domains[0] : null
  default_ha_availability_domain = var.ha_gw && local.cloud == "oci" ? (try(aviatrix_vpc.default[0].availability_domains[1], aviatrix_vpc.default[0].availability_domains[0])) : null
  default_ha_fault_domain        = var.ha_gw && local.cloud == "oci" ? aviatrix_vpc.default[0].fault_domains[1] : null

  availability_domain    = var.availability_domain != null ? var.availability_domain : local.default_availability_domain
  ha_availability_domain = var.ha_availability_domain != null ? var.ha_availability_domain : local.default_ha_availability_domain
  fault_domain           = var.fault_domain != null ? var.fault_domain : local.default_fault_domain
  ha_fault_domain        = var.ha_fault_domain != null ? var.ha_fault_domain : local.default_ha_fault_domain

  enable_transit_firenet = var.enable_transit_firenet || var.enable_egress_transit_firenet #Automatically toggle transit firenet true, if egress transit firenet is enabled

  #VPC Type Settings
  aviatrix_transit_vpc = contains(["ali"], local.cloud) || var.legacy_transit_vpc
  aviatrix_firenet_vpc = (var.legacy_transit_vpc || var.private_mode_subnets ?
    false
    :
    contains(["aws", "azure", "oci"], local.cloud)
  )

  #GCP BGP over LAN
  bgp_lan_default_name = local.cloud == "gcp" ? [for i, v in var.bgp_lan_interfaces : "${local.name}-bgp-${i}"] : [] # Generate names for creating primary BGP over LAN VPCs.
  ha_bgp_lan_default_name = var.ha_gw && local.cloud == "gcp" ? [for i, v in var.bgp_lan_interfaces :                # Compare subnets specified for primary and HA. If they're the same, we use the primary name.
  v["subnet"] == var.ha_bgp_lan_interfaces[i]["subnet"] ? local.bgp_lan_default_name[i] : "${local.name}-ha-bgp-${i}"] : []

  #Create map of final primary BGP VPC to subnets for the aviatrix_transit_gateway resource.
  bgp_lan_interfaces = local.cloud == "gcp" ? { for i, v in var.bgp_lan_interfaces : (v["vpc_id"] == "" ? local.bgp_lan_default_name[i] : i) => {
    subnet     = v["subnet"],
    vpc_id     = v["vpc_id"] == "" ? local.bgp_lan_default_name[i] : v["vpc_id"],
    create_vpc = v["vpc_id"] == "" ? true : v["create_vpc"] # Create a VPC using the default name if the vpc_id is unspecified. Otherwise, create the VPC based on the boolean value.
  } } : {}
  ha_bgp_lan_interfaces = var.ha_gw && local.cloud == "gcp" ? { for i, v in var.ha_bgp_lan_interfaces : (v["vpc_id"] == "" ? local.ha_bgp_lan_default_name[i] : i) => {
    subnet     = v["subnet"],
    vpc_id     = v["vpc_id"] == "" ? local.ha_bgp_lan_default_name[i] : v["vpc_id"],
    create_vpc = v["vpc_id"] == "" ? true : v["create_vpc"] # Create a VPC using the default name if the vpc_id is unspecified. Otherwise, create the VPC based on the boolean value.
  } } : {}

  # Create a map of VPCs to create by filtering the entries with the create_vpc value set to false.
  bgp_lan_vpcs_to_create = local.cloud == "gcp" ? { for k, v in local.bgp_lan_interfaces : k => v["subnet"] if v["create_vpc"] } : {}

  ha_bgp_lan_vpcs_to_create = var.ha_gw && local.cloud == "gcp" ? { for k, v in local.ha_bgp_lan_interfaces :
    k => v["subnet"] if v["create_vpc"] &&
  contains(values(local.bgp_lan_vpcs_to_create), v["subnet"]) == false } : {} # Also filter out entries where the subnet CIDR is the same as primary so we don't try to create the same vpc twice.
}
