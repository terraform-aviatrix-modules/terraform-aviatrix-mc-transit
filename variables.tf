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
  nullable    = false

  validation {
    condition     = length(var.name) <= 50
    error_message = "Name is too long. Max length is 50 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]*$", var.name))
    error_message = "For the transit name value only a-z, A-Z, 0-9 and hyphens and underscores are allowed."
  }
}

variable "gw_name" {
  description = "Name for the transit gateway"
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = length(var.gw_name) <= 50
    error_message = "Name is too long. Max length is 50 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]*$", var.gw_name))
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
  nullable    = false
}

variable "hybrid_connection" {
  description = "Set to true to prepare Aviatrix transit for TGW connection."
  type        = bool
  default     = false
  nullable    = false
}

variable "bgp_manual_spoke_advertise_cidrs" {
  description = "Define a list of CIDRs that should be advertised via BGP."
  type        = string
  default     = ""
  nullable    = false
}

variable "learned_cidr_approval" {
  description = "Set to true to enable learned CIDR approval."
  type        = string
  default     = "false"
  nullable    = false
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
  nullable    = false
}

variable "ha_region" {
  description = "Secondary GCP region where subnet and HA Aviatrix Transit Gateway will be created"
  type        = string
  default     = ""
  nullable    = false
}

variable "cidr" {
  description = "The CIDR range to be used for the VPC"
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = var.cidr != "" ? can(cidrnetmask(var.cidr)) : true
    error_message = "This does not like a valid CIDR."
  }
}

variable "ha_cidr" {
  description = "CIDR of the HA GCP subnet"
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = var.ha_cidr != "" ? can(cidrnetmask(var.ha_cidr)) : true
    error_message = "This does not like a valid CIDR."
  }
}

variable "lan_cidr" {
  description = "The CIDR range to be used for the LAN VPC for Firenet in GCP"
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = var.lan_cidr != "" ? can(cidrnetmask(var.lan_cidr)) : true
    error_message = "This does not like a valid CIDR."
  }
}

variable "enable_firenet" {
  description = "Sign of readiness for FireNet connection"
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_transit_firenet" {
  description = "Sign of readiness for Transit FireNet connection"
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_egress_transit_firenet" {
  description = "Enable Egress Transit FireNet"
  type        = bool
  default     = false
  nullable    = false
}

variable "bgp_polling_time" {
  description = "BGP route polling time. Unit is in seconds"
  type        = string
  default     = "50"
  nullable    = false
}

variable "bgp_ecmp" {
  description = "Enable Equal Cost Multi Path (ECMP) routing for the next hop"
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_multi_tier_transit" {
  description = "Set to true to enable multi tier transit."
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_advertise_transit_cidr" {
  description = "Switch to enable/disable advertise transit VPC network CIDR for a VGW connection"
  type        = bool
  default     = false
  nullable    = false
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
  nullable    = false
}

variable "account" {
  description = "The AWS account name, as known by the Aviatrix controller"
  type        = string
}

variable "instance_size" {
  description = "Instance size for the Aviatrix gateways"
  type        = string
  default     = ""
  nullable    = false
}

variable "ha_gw" {
  description = "Boolean to determine if module will be deployed in HA or single mode"
  type        = bool
  default     = true
  nullable    = false
}

variable "insane_mode" {
  description = "Set to true to enable Aviatrix high performance encryption."
  type        = bool
  default     = false
  nullable    = false
}

variable "az1" {
  description = "Concatenates with region to form az names. e.g. eu-central-1a. Only used for insane mode"
  type        = string
  default     = ""
  nullable    = false
}

variable "az2" {
  description = "Concatenates with region to form az names. e.g. eu-central-1b. Only used for insane mode"
  type        = string
  default     = ""
  nullable    = false
}

variable "az_support" {
  description = "Set to true if the Azure region supports AZ's"
  type        = bool
  default     = true
  nullable    = false
}

variable "single_az_ha" {
  description = "Set to true if Controller managed Gateway HA is desired"
  type        = bool
  default     = true
  nullable    = false
}

variable "single_ip_snat" {
  description = "Specify whether to enable Source NAT feature in single_ip mode on the gateway or not. Please disable AWS NAT instance before enabling this feature. Currently only supports AWS(1) and AZURE(8). Valid values: true, false."
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_encrypt_volume" {
  description = "Enable EBS volume encryption for Gateway. Only supports AWS and AWSGOV provider. Valid values: true, false. Default value: false"
  type        = bool
  default     = false
  nullable    = false
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
  nullable    = false
}

variable "ha_bgp_lan_interfaces" {
  description = "Interfaces to run BGP protocol on top of the ethernet interface."
  type        = list(any)
  default     = []
  nullable    = false
}

variable "enable_active_standby_preemptive" {
  description = "Enables Preemptive Mode for Active-Standby. Available only with BGP enabled, HA enabled and Active-Standby enabled."
  type        = bool
  default     = false
  nullable    = false
}

variable "legacy_transit_vpc" {
  description = "Retains pre v2.x behavior of the module, where it creates a transit VPC instead of firenet VPC in AWS." #Deliberately unpublished in readme
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_s2c_rx_balancing" {
  description = "Allows to toggle the S2C receive packet CPU re-balancing on transit gateway."
  type        = bool
  default     = false
  nullable    = false
}

variable "rx_queue_size" {
  description = "Gateway ethernet interface RX queue size. Once set, can't be deleted or disabled."
  type        = string
  default     = null

  validation {
    condition     = var.rx_queue_size != null ? contains(["1K", "2K", "4K", "8K", "16K"], var.rx_queue_size) : true
    error_message = "Expected rx_queue_size to be one of [1K 2K 4K 8K 16K]."
  }
}

variable "availability_domain" {
  description = "Availability domain in OCI."
  type        = string
  default     = null
}

variable "ha_availability_domain" {
  description = "Availability domain in OCI for HA GW."
  type        = string
  default     = null
}

variable "fault_domain" {
  description = "Fault domain in OCI."
  type        = string
  default     = null
}

variable "ha_fault_domain" {
  description = "Fault domain in OCI for HA GW."
  type        = string
  default     = null
}

variable "enable_preserve_as_path" {
  description = "Enable preserve as_path when advertising manual summary cidrs on BGP transit gateway."
  type        = bool
  default     = null
}

variable "enable_gateway_load_balancer" {
  description = "Enable FireNet interfaces with AWS Gateway Load Balancer."
  type        = bool
  default     = null
}

variable "enable_active_standby" {
  description = "Enables Active-Standby Mode. Available only with HA enabled."
  type        = bool
  default     = null
}

variable "bgp_lan_interfaces_count" {
  description = "Number of interfaces that will be created for BGP over LAN enabled Azure transit."
  default     = null
  type        = number

  validation {
    condition     = var.bgp_lan_interfaces_count != null ? (var.bgp_lan_interfaces_count >= 1 && var.bgp_lan_interfaces_count <= 7) : true
    error_message = "Maximum interfaces supported is 7, or 5 when Firenet is used."
  }
}

variable "private_mode_lb_vpc_id" {
  description = "VPC ID of Private Mode load balancer. Required when Private Mode is enabled on the Controller."
  type        = string
  default     = null
}

variable "private_mode_subnets" {
  description = "Switch to only launch private subnets. Only available when Private Mode is enabled on the Controller."
  type        = bool
  default     = false
  nullable    = false
}

variable "allocate_new_eip" {
  description = "When value is false, reuse an idle address in Elastic IP pool for this gateway. Otherwise, allocate a new Elastic IP and use it for this gateway."
  type        = bool
  default     = null
}

variable "eip" {
  description = "Required when allocate_new_eip is false. It uses the specified EIP for this gateway."
  type        = string
  default     = null
}

variable "ha_eip" {
  description = "Required when allocate_new_eip is false. It uses the specified EIP for this gateway."
  type        = string
  default     = null
}

variable "azure_eip_name_resource_group" {
  description = "Name of public IP Address resource and its resource group in Azure to be assigned to the Transit Gateway instance."
  type        = string
  default     = null
}

variable "ha_azure_eip_name_resource_group" {
  description = "Name of public IP Address resource and its resource group in Azure to be assigned to the Transit Gateway instance."
  type        = string
  default     = null
}

locals {
  cloud                 = lower(var.cloud)
  name                  = coalesce(var.name, local.default_name)
  gw_name               = coalesce(var.gw_name, local.name)
  suffix                = var.enable_egress_transit_firenet ? "-egress" : "-transit"
  region_name           = lower(replace(trim(split("(", var.region)[0], " "), " ", "-")) # Remove everything after "(" (Alibaba), trim whitespace and replace spaces with dashes. Force lowercase.
  default_name          = format("avx-%s%s", local.region_name, local.suffix)
  cidr                  = var.cidr
  cidrbits              = tonumber(split("/", local.cidr)[1])
  newbits               = 26 - local.cidrbits
  netnum                = pow(2, local.newbits)
  insane_mode_subnet    = var.insane_mode || var.private_mode_subnets ? cidrsubnet(local.cidr, local.newbits, local.netnum - 2) : null
  ha_insane_mode_subnet = var.insane_mode || var.private_mode_subnets ? cidrsubnet(local.cidr, local.newbits, local.netnum - 1) : null

  #Auto disable AZ support for gov and dod regions in Azure
  az_support = local.is_gov ? false : var.az_support

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

  subnet = (
    (var.insane_mode && contains(["aws", "azure", "oci"], local.cloud)) || (var.private_mode_subnets && contains(["aws", "azure"], local.cloud)) ?
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
    oci   = 3,
    ali   = 0,
  }

  ha_subnet = (
    (var.insane_mode && contains(["aws", "azure", "oci"], local.cloud)) || (var.private_mode_subnets && contains(["aws", "azure"], local.cloud)) ?
    local.ha_insane_mode_subnet
    :
    (local.cloud == "gcp" ?
      aviatrix_vpc.default.subnets[local.ha_subnet_map[local.cloud]].cidr
      :
      (local.single_az_mode ?
        local.subnet
        :
        aviatrix_vpc.default.public_subnets[local.ha_subnet_map[local.cloud]].cidr
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
  default_availability_domain    = local.cloud == "oci" ? aviatrix_vpc.default.availability_domains[0] : null
  default_fault_domain           = local.cloud == "oci" ? aviatrix_vpc.default.fault_domains[0] : null
  default_ha_availability_domain = var.ha_gw && local.cloud == "oci" ? (try(aviatrix_vpc.default.availability_domains[1], aviatrix_vpc.default.availability_domains[0])) : null
  default_ha_fault_domain        = var.ha_gw && local.cloud == "oci" ? aviatrix_vpc.default.fault_domains[1] : null

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
}
