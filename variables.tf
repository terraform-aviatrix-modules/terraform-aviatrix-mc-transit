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

variable "approved_learned_cidrs" {
  description = "A set of approved learned CIDRs. Only valid when enable_learned_cidrs_approval is set to true."
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
  type = list(object(
    {
      vpc_id     = optional(string, "")
      subnet     = string,
      create_vpc = optional(bool, false)
    }
  ))
  default  = []
  nullable = false
}

variable "ha_bgp_lan_interfaces" {
  description = "Interfaces to run BGP protocol on top of the ethernet interface."
  type = list(object(
    {
      vpc_id     = optional(string, "")
      subnet     = string,
      create_vpc = optional(bool, false)
    }
  ))
  default  = []
  nullable = false
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

variable "enable_monitor_gateway_subnets" {
  description = "Enables Monitor Gateway Subnet feature in AWS"
  type        = bool
  default     = false
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

variable "enable_vpc_dns_server" {
  description = "Enable VPC DNS Server for Gateway."
  type        = bool
  default     = null
}

variable "enable_gro_gso" {
  description = "Enable GRO/GSO for this transit gateway."
  type        = bool
  default     = null
}

variable "bgp_hold_time" {
  description = "Set the BGP Hold time."
  default     = null
  type        = number

  validation {
    condition     = var.bgp_hold_time != null ? (var.bgp_hold_time >= 12 && var.bgp_hold_time <= 360) : true
    error_message = "BGP Hold time needs to be between 12 and 360 seconds."
  }
}

variable "use_existing_vpc" {
  description = "Set to true to use existing VPC."
  default     = false
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID, for using an existing VPC."
  type        = string
  default     = ""
  nullable    = false
}

variable "gw_subnet" {
  description = "Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is true"
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = var.gw_subnet == "" || can(cidrnetmask(var.gw_subnet))
    error_message = "This does not like a valid CIDR."
  }
}

variable "hagw_subnet" {
  description = "Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is true and ha_gw is true"
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = var.hagw_subnet == "" || can(cidrnetmask(var.hagw_subnet))
    error_message = "This does not like a valid CIDR."
  }
}

variable "customized_transit_vpc_routes" {
  description = "A list of CIDRs to be customized for the transit VPC routes."
  type        = list(string)
  default     = null
}
