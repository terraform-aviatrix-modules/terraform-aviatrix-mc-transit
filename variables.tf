variable "cloud" {
  description = "Cloud type"
  type        = string

  validation {
    condition     = contains(["aws", "azure", "oci", "ali", "gcp"], lower(var.cloud))
    error_message = "Invalid cloud type. Choose AWS, Azure, GCP, ALI or OCI."
  }
}

variable "name" {
  description = "Name for this transit VPC and it's gateways"
  type        = string
  default     = ""

  validation {
    condition     = length(var.name) <= 50
    error_message = "Name is too long. Max length is 50 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]*$", var.name))
    error_message = "For the transit name value only a-z, A-Z, 0-9 and hyphens and underscores are allowed."
  }
}

variable "region" {
  description = "The region to deploy this module in"
  type        = string
}

variable "connected_transit" {
  description = "Set to false to disable connected transit."
  type        = bool
  default     = true
}

variable "hybrid_connection" {
  description = "Set to true to prepare Aviatrix transit for TGW connection."
  type        = bool
  default     = false
}

variable "bgp_manual_spoke_advertise_cidrs" {
  description = "Define a list of CIDRs that should be advertised via BGP."
  type        = string
  default     = ""
}

variable "learned_cidr_approval" {
  description = "Set to true to enable learned CIDR approval."
  type        = string
  default     = "false"
}

variable "learned_cidrs_approval_mode" {
  description = "Learned cidrs approval mode. Defaults to Gateway. Valid values: gateway, connection"
  type        = string
  default     = null
}

variable "enable_segmentation" {
  description = "Switch to true to enable transit segmentation"
  type        = bool
  default     = false
}

variable "ha_region" {
  description = "Secondary GCP region where subnet and HA Aviatrix Transit Gateway will be created"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "The CIDR range to be used for the VPC"
  type        = string
  default     = ""

  validation {
    condition     = var.cidr != "" ? can(cidrnetmask(var.cidr)) : true
    error_message = "This does not like a valid CIDR."
  }
}

variable "ha_cidr" {
  description = "CIDR of the HA GCP subnet"
  type        = string
  default     = ""

  validation {
    condition     = var.ha_cidr != "" ? can(cidrnetmask(var.ha_cidr)) : true
    error_message = "This does not like a valid CIDR."
  }
}

variable "enable_firenet" {
  description = "Sign of readiness for FireNet connection"
  type        = bool
  default     = false
}

variable "enable_transit_firenet" {
  description = "Sign of readiness for Transit FireNet connection"
  type        = bool
  default     = false
}

variable "enable_egress_transit_firenet" {
  description = "Enable Egress Transit FireNet"
  type        = bool
  default     = false
}

variable "bgp_polling_time" {
  description = "BGP route polling time. Unit is in seconds"
  type        = string
  default     = "50"
}

variable "bgp_ecmp" {
  description = "Enable Equal Cost Multi Path (ECMP) routing for the next hop"
  type        = bool
  default     = false
}

variable "enable_multi_tier_transit" {
  description = "Set to true to enable multi tier transit."
  type        = bool
  default     = false
}

variable "enable_advertise_transit_cidr" {
  description = "Switch to enable/disable advertise transit VPC network CIDR for a VGW connection"
  type        = bool
  default     = false
}

variable "local_as_number" {
  description = "Changes the Aviatrix Transit Gateway ASN number before you setup Aviatrix Transit Gateway connection configurations."
  type        = string
  default     = null
}

variable "enable_bgp_over_lan" {
  description = "Enable BGP over LAN. Creates eth4 for integration with SDWAN for example"
  type        = bool
  default     = false
}

variable "account" {
  description = "The AWS account name, as known by the Aviatrix controller"
  type        = string
}

variable "instance_size" {
  description = "Instance size for the Aviatrix gateways"
  type        = string
  default     = ""
}

variable "ha_gw" {
  description = "Boolean to determine if module will be deployed in HA or single mode"
  type        = bool
  default     = true
}

variable "insane_mode" {
  description = "Set to true to enable Aviatrix high performance encryption."
  type        = bool
  default     = false
}

variable "az1" {
  description = "Concatenates with region to form az names. e.g. eu-central-1a. Only used for insane mode"
  type        = string
  default     = ""
}

variable "az2" {
  description = "Concatenates with region to form az names. e.g. eu-central-1b. Only used for insane mode"
  type        = string
  default     = ""
}

variable "az_support" {
  description = "Set to true if the Azure region supports AZ's"
  type        = bool
  default     = true
}

variable "single_az_ha" {
  description = "Set to true if Controller managed Gateway HA is desired"
  type        = bool
  default     = true
}

variable "single_ip_snat" {
  description = "Specify whether to enable Source NAT feature in single_ip mode on the gateway or not. Please disable AWS NAT instance before enabling this feature. Currently only supports AWS(1) and AZURE(8). Valid values: true, false."
  type        = bool
  default     = false
}

variable "enable_encrypt_volume" {
  description = "Enable EBS volume encryption for Gateway. Only supports AWS and AWSGOV provider. Valid values: true, false. Default value: false"
  type        = bool
  default     = false
}

variable "customer_managed_keys" {
  description = "Customer managed key ID for EBS Volume encryption."
  type        = string
  default     = null
}

variable "tunnel_detection_time" {
  description = "The IPsec tunnel down detection time for the Transit Gateway in seconds. Must be a number in the range [20-600]."
  type        = number
  default     = null

  validation {
    condition     = var.tunnel_detection_time != null ? (var.tunnel_detection_time >= 20 && var.tunnel_detection_time <= 600) : true
    error_message = "Invalid value. Must be in range 20-600."
  }
}

variable "tags" {
  description = "Map of tags to assign to the gateway."
  type        = map(string)
  default     = null
}

variable "resource_group" {
  description = "Provide the name of an existing resource group."
  type        = string
  default     = null
}

variable "bgp_lan_interfaces" {
  description = "Interfaces to run BGP protocol on top of the ethernet interface."
  type        = list(any)
  default     = []
}

variable "ha_bgp_lan_interfaces" {
  description = "Interfaces to run BGP protocol on top of the ethernet interface."
  type        = list(any)
  default     = []
}

variable "enable_active_standby_preemptive" {
  description = "Enables Preemptive Mode for Active-Standby. Available only with BGP enabled, HA enabled and Active-Standby enabled."
  type        = bool
  default     = false
}

variable "legacy_transit_vpc" {
  description = "Retains pre v2.x behavior of the module, where it creates a transit VPC instead of firenet VPC in AWS." #Deliberately unpublished in readme
  type        = bool
  default     = false
}

locals {
  cloud                 = lower(var.cloud)
  name                  = coalesce(var.name, local.default_name)
  default_name          = lower(replace("avx-${var.region}-transit", " ", "-")) #Remove spaces from region names and force lowercase
  cidr                  = var.cidr
  cidrbits              = tonumber(split("/", local.cidr)[1])
  newbits               = 26 - local.cidrbits
  netnum                = pow(2, local.newbits)
  insane_mode_subnet    = cidrsubnet(local.cidr, local.newbits, local.netnum - 2)
  ha_insane_mode_subnet = cidrsubnet(local.cidr, local.newbits, local.netnum - 1)

  az1 = length(var.az1) > 0 ? var.az1 : lookup(local.az1_map, local.cloud, null)
  az1_map = {
    azure = var.az_support ? "az-1" : null,
    aws   = "a",
    gcp   = "b",
  }

  az2 = length(var.az2) > 0 ? var.az2 : lookup(local.az2_map, local.cloud, null)
  az2_map = {
    azure = var.az_support ? "az-2" : null,
    aws   = "b",
    gcp   = "c",
  }

  subnet = (
    var.insane_mode && contains(["aws", "azure"], local.cloud) ?
    local.insane_mode_subnet
    :
    (local.cloud == "gcp" ?
      aviatrix_vpc.default.subnets[local.subnet_map[local.cloud]].cidr
      :
      aviatrix_vpc.default.public_subnets[local.subnet_map[local.cloud]].cidr
    )
  )

  subnet_map = {
    azure = 2,
    aws   = 0
    gcp   = 0,
    oci   = 0,
    ali   = 0,
  }

  ha_subnet = (
    var.insane_mode && contains(["aws", "azure"], local.cloud) ?
    local.ha_insane_mode_subnet
    :
    (local.cloud == "gcp" ?
      aviatrix_vpc.default.subnets[local.ha_subnet_map[local.cloud]].cidr
      :
      aviatrix_vpc.default.public_subnets[local.ha_subnet_map[local.cloud]].cidr
    )
  )

  ha_subnet_map = {
    azure = 3,
    aws   = 2
    gcp   = length(var.ha_region) > 0 ? 1 : 0
    oci   = 0,
    ali   = 1,
  }

  region = local.cloud == "gcp" ? "${var.region}-${local.az1}" : var.region

  zone = local.cloud == "azure" ? local.az1 : null

  ha_zone = lookup(local.ha_zone_map, local.cloud, null)
  ha_zone_map = {
    azure = local.az2,
    gcp   = local.cloud == "gcp" ? "${coalesce(var.ha_region, var.region)}${local.az2}" : null
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
  is_china    = can(regex("^cn-|^China ", var.region)) && contains(["aws", "azure"], local.cloud)             #If a region in Azure or AWS starts with China prefix, then results in true.
  is_gov      = can(regex("^us-gov|^US Gov ", var.region)) && contains(["aws", "azure"], local.cloud)         #If a region in Azure or AWS starts with Gov prefix, then results in true.
  check_china = local.is_china ? lookup(local.cloud_type_map_china, local.cloud, null) : null                 #Returns cloud type only if is_china is true, else null
  check_gov   = local.is_gov ? lookup(local.cloud_type_map_gov, local.cloud, null) : null                     #Returns cloud type only if is_gov is true, else null
  cloud_type  = coalesce(local.check_china, local.check_gov, lookup(local.cloud_type_map, local.cloud, null)) #Takes first found value

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
      var.insane_mode || var.enable_transit_firenet ?
      lookup(local.insane_mode_instance_size_map, local.cloud, null) #If instance size is not provided and var.insane_mode or var.enable_transit_firenet is true, lookup in this table.
      :                                                              #
      lookup(local.instance_size_map, local.cloud, null)             #If instance size is not provided and var.insane_mode and var.enable_transit_firenet are false, lookup in this table.
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
    oci   = "VM.Standard2.2",
    ali   = null
  }

  single_az_mode = false #Needs to be implemented
}
