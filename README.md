# terraform-aviatrix-mc-transit

### Description
Deploys a VPC/VNET/VCN and Aviatrix Transit gateways.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.1.2 | 0.13-1.x | >= 6.6.5404 | 2.21.1-6.6.ga
v1.1.1 | 0.13-1.x | >= 6.6.5404 | 2.21.1-6.6.ga
v1.1.0 | 0.13-1.x | >= 6.6 | 2.21.0-6.6.ga
v1.0.1 | 0.13-1.x | 6.4 - 6.5 | >= 2.19.0
v1.0.0 | 0.13-1.x | 6.4 - 6.5 | >= 2.19.0

v1.1.2 fixes an issue where the hagw was deployed in the wrong subnet. Applying it requires rebuilding the hagw. This is strongly recommended however, to make sure the transit can cope with a full AZ outage.

### Usage Examples
See examples

### Variables
The following variables are required:

key | value
:--- | :---
cloud | Cloud where this is deployed. Valid values: "AWS", "Azure", "ALI", "OCI", "GCP"
region | Cloud region to deploy this VPC/VNET/VCN in
cidr | What ip CIDR to use for this VPC/VNET/VCN
account | The account name as known by the Aviatrix controller

The following variables are optional:

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> = AWS, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> = Azure, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> = GCP, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> = OCI, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> = Alibaba


Key | Supported_CSP's |  Default value | Description
:-- | --: | :-- | :--
az_support | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> | true | Set to false if the region does not support Availability Zones.
az1 | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> | a<br>az-1<br>b | Concatenates with region to form az names. e.g. eu-central-1a. Used for insane mode only.
az2 | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> | b<br>az-2<br>c | Concatenates with region to form az names. e.g. eu-central-1b. Used for insane mode only.
bgp_ecmp |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> |  false | Enable Equal Cost Multi Path (ECMP) routing for the next hop
bgp_lan_interfaces | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> | | Interfaces to run BGP protocol on top of the ethernet interface
bgp_manual_spoke_advertise_cidrs |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> |  | Intended CIDR list to advertise via BGP. Example: "10.2.0.0/16,10.4.0.0/16" 
bgp_polling_time | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | 50 | BGP route polling time. Unit is in seconds
connected_transit | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | true | Set to false to disable connected_transit
customer_managed_keys | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> | | Customer managed key ID for EBS Volume encryption.
enable_active_standby_preemptive | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | false | Enables Preemptive Mode for Active-Standby. Available only with BGP enabled, HA enabled and Active-Standby enabled.
enable_advertise_transit_cidr | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | false | Switch to enable/disable advertise transit VPC network CIDR for a VGW connection
enable_bgp_over_lan | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> | false | Enable BGP over LAN. Creates interface for integration with SDWAN or other BGP peerings over LAN.
enable_egress_transit_firenet | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> | false | Enable Egress Transit FireNet
enable_encrypt_volume | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> | false | Set to true to enable EBS volume encryption for Gateway.
enable_firenet |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> | false | Sign of readiness for FireNet connection with TGW
enable_multi_tier_transit |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | false |	Switch to enable multi tier transit
enable_segmentation | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | false | Switch to true to enable transit segmentation
enable_transit_firenet  | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> | false | Sign of readiness for Transit FireNet connection
ha_bgp_lan_interfaces | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> | | Interfaces to run BGP protocol on top of the ethernet interface
ha_cidr | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> | | The IP CIDR to be used to create ha_region spoke subnet. Only required when ha_region is set.
ha_gw |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | true | Set to false if you only want to deploy a single Aviatrix spoke gateway
ha_region | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> | | Region for multi region HA. HA is multi-az single region by default, but will become multi region when this is set.
hybrid_connection | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> | false | Sign of readiness for TGW connection
insane_mode | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> | false | Set to true to enable insane mode encryption
instance_size | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | t3.medium<br>Standard_B1ms<br>n1-standard-1<br>VM.Standard2.2<br>ecs.g5ne.large | The size of the Aviatrix transit gateways.
instance_size (insane mode) | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"><br><img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> | c5n.large<br>Standard_D3_v2<br>n1-highcpu-4<br>VM.Standard2.2 | The size of the Aviatrix transit gateways when insane mode is enabled.
learned_cidr_approval | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | false | Switch to true to enable learned CIDR approval
learned_cidrs_approval_mode |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> |  | Learned cidrs approval mode. Defaults to Gateway. Valid values: gateway, connection
local_as_number |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> |  | Changes the Aviatrix Transit Gateway ASN number before you setup Aviatrix Transit Gateway connection configurations.
name | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | avx-\<region\>-transit | Name for this Transit VPC/VNET/VCN and it's gateways
single_az_ha | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | true | Set to false if Controller managed Gateway HA is desired
single_ip_snat | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | false | Specify whether to enable Source NAT feature in single_ip mode on the gateway or not. Please disable AWS NAT instance before enabling this feature. Currently only supports AWS(1) and AZURE(8)
tags |<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> | | Map of tags to assign to the gateway.
tunnel_detection_time | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/azure.png?raw=true" title="Azure"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/gcp.png?raw=true" title="GCP"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/oci.png?raw=true" title="OCI"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit/blob/main/img/alibaba.png?raw=true" title="Alibaba"> | | The IPsec tunnel down detection time for the Spoke Gateway in seconds. Must be a number in the range [20-600]. Default is 60.

### Outputs
This module will return the following outputs:

key | description
:---|:---
[vpc](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_vpc) | The created VPC as an object with all of it's attributes (when use_existing_vpc is false). This was created using the aviatrix_vpc resource.
[transit_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_transit_gateway) | The created Aviatrix transit gateway as an object with all of it's attributes.

