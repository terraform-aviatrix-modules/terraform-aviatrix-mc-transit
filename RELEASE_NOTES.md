# terraform-aviatrix-mc-transit release notes

## 8.0.1
- Automatically disables az_support if region is Azure China.

## 8.0.0
### Version Alignment
Starting with this release, this Terraform module will align its version with the Aviatrix Controller version. This means the module version has jumped from v2.6.0 to v8.0.0 to align with the Controller’s latest major version. This change makes it easier to determine which module version is compatible with which Controller version.

### Relaxed version constraints
Starting with this release, this Terraform module will move from a pessimistic constraint operator (`~>`) to a more relaxed provider version constraint (`>=`). As a result of this, module versions 8.0.0 and above can be used with newer (future) version of the Aviatrix Terraform provider, with the constraint that the newer provider version cannot have behavioral changes.
The reason for this change is to allow users to upgrade their controller and Terraform provider versions, without requiring to upgrade all their Terraform module versions, unless any of the following exceptions are true:
- User requires access to new feature flags, that are only exposed in newer Terraform module versions.
- The new Terraform provider version does not introduce behavior changes that are incompatible with the module version.

### Future releases
A new major module version will be released _only_ when:
- A new major Aviatrix Terraform provider has been released AND introduces new features or breaking changes.

A new minor module version will be released when:
- Bug fixes or missed features that were already available in the same release train as the Aviatrix Terraform provider.

## v2.6.0

### Add support for Aviatrix controller version 7.2 and Terraform provider version 3.2.x.

## v2.5.4

### Add support for enable_transit_summarize_cidr_to_tgw

### Add support for excluded_advertised_spoke_routes

## v2.5.3

### Add support for customized_transit_vpc_routes
### Add support for approved_learned_cidrs
### Add support for filtered_spoke_vpc_routes

## v2.5.2

### Add support for bring your own VNET/VPC
It is encouraged to let the mc-transit module build the transit VPC/VNET in stead of bringing your own. In some scenario's however, it can be useful to have more control over the VPC/VNET creation. For example when you want to enable a DDoS plan on a VNET, or need to create additional subnets like a GatewaySubnet for deployment of an Azure Route Server/VPN Gateway.

Using existing VPC/VNET's breaks compatibility with mc-firenet module versions up to and including 1.5.3. Use 1.5.4 or newer.

It can take a while for the controller to be able to find the byo VNET after creation. If deployment of the mc-transit module fails with this error: "Cannot find VNET resource group or VNET CIDR.", try again later.

## v2.5.1

### Add support for configuring bgp hold time on transit gateway.

## v2.5.0

### Compatibility with controller version 7.1 and Terraform provider version 3.1.x

### Implemented support for GRO/GSO on this gateway.
Enabled by default and enhances gateway performance. This setting can be used to turn it off.

### Broken out locals to separate file
For beter readability, the locals are no longer part of variables.tf and can now be found in locals.tf.

## v2.4.2

### Add support for GCP BGP over LAN VPC creation.

## v2.4.1

### Add support for enable_vpc_dns_server

## v2.4.0

### Add support for Controller version 7.0 and Terraform provider version 3.0.0.
This release is providing compatibility with these versions.

## v2.3.2

### Add support for dual transit firenet configuration for GCP

## v2.3.1

### Add support for enabling gateway subnet monitoring in AWS

## v2.3.0

### Controller version 6.9 / Terraform provider version 2.24.x compatibility

## v2.2.1

### Add support for customizing EIP settings.
5 new arguments have been added, to configure the transit gateway with custom EIP settings:
- allocate_new_eip
- eip
- ha_eip
- azure_eip_name_resource_group
- ha_azure_eip_name_resource_group

### Change private mode behavior (better logic and automation)

## v2.2.0

### Add support for 6.8 and provider version 2.23.0.

### Add support for bgp_lan_interfaces_count argument
This argument is used to add additional interfaces in order to set up BGP over LAN in Azure.

### Add support for private mode
These arguments were added to support this:
- private_mode_subnets
- private_mode_lb_vpc_id
- private_mode_subnet_zone
- ha_private_mode_subnet_zone

## v2.1.6

### Fix an issue where using a `cidr` smaller than /26 cause a function error.

### Revert marking outputs as sensitive
In order to allow for using this module directly as root module in Terragrunt, the transit_gateway output was marked as sensitive before. This has proven to have undesireable side effects in vanilla Terraform operations. To use this module in Terragrunt, you need to wrap it in Terraform code or a wrapper module in stead.

### Add support for active/standby mode through enable_active_standby argument.

## v2.1.5

### Add support for enable_gateway_load_balancer on transit gateway (AWS Only).

## v2.1.4

### Add support for provider 2.22.1.

### Add support for new argument enable_preserve_as_path

## v2.1.3

### Automatically truncate VPC/VNET/VCN names at 30 characters
When not explicitly configuring the transit name, the default name could exceed 30 characters for regions with long names. In Alibaba the region description within paranthesis automatically gets dropped as well. So "acs-us-east-1 (Virginia)" will become "acs-us-east-1".

### Set output aviatrix_transit_gateway to sensitive for terragrunt compatibility.

## v2.1.2

### Automatically disable AZ support for Azure Gov and DoD regions
As availability zones are not supported in the Aviatrix controller for Gov and DoD regions, the module automatically selects az_support = false, for these regions.

## v2.1.1

### Make OCI availability and fault domains user configurable.
New variables available for configuration:
```
availability_domain
ha_availability_domain
fault_domain
ha_fault_domain
```

### Fix OCI availability domains selection for single AD regions.
Previously, the module assumed multiple AD's available in every region. As per this release, it can handle single AD regions as well.

## v2.1.0

### Add support for controller version 6.7 and provider version 2.22.0.

### Add support for rx_queue_size
This option allows you to increase the receive buffer size. This may be required in scenarios where traffic is particularly bursty.

## v2.0.3

### Improved Azure GOV and DoD region detection
Previously regex mismatched the regions, resulting in the wrong cloud type.

## v2.0.2

### Change default name for egress transit
When creating a transit gateway with enable_egress_transit_firenet enabled, the transit name will end in -egress in stead of -transit. This is done to simplify dual transit firenet deployments, as multiple transits in a ingle region would by default otherwise collide with the same name. If this behavior is underdesired for your deployment, you can negate it by manually setting the name in the name argument.

### Adding option to differentiate naming between transit gateway and VNET/VPC/VCN
By default, the same name is used for VPC and transit gateway. This behavior can now be overridden by setting the gw_name argument. Default behavior has not changed.

## v2.0.1
This version of the module was released to support usage in combination with the [mc-transit-deployment-framework module](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-deployment-framework).

### Input variables non-nullable
Most input variables that have a default value, have been set to be non-nullable as of this release. This allows parent or root modules calling this module to set arguments to null without changing the internal behavior of the module. This should cause no impact to existing usage.

### Fix OCI Insane mode bug
Due to internal module logic, the wrong subnet was selected for insane mode, when using this module in OCI.

## v2.0.0
This version of the module was released to support usage in combination with the [mc-firenet module](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-firenet).
Some behaviors had to be adjusted, in order to extend this module with the mc-firenet module.

### VPC behavior
Previously, this module would create a [transit VPC](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_vpc#aviatrix_transit_vpc) in AWS. For propper integration with firenet, this needed to change to a [Firenet VPC](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_vpc#aviatrix_firenet_vpc). As this is a breaking change and if you do not want to change your current deployment or deploy firenet, there is a (hidden) backward compatibility flag that you can set, to retain transit VPC behavior.

```
legacy_vpc = true
```

## v1.1.4

### Improved Azure GOV and DoD region detection
Previously regex mismatched the regions, resulting in the wrong cloud type.

## v1.1.3

### Add support for provider version 2.21.2.

### Add support for enable_s2c_rx_balancing
Allows to toggle the S2C receive packet CPU re-balancing on transit gateway.

## v1.1.2

### Fix wrong subnet for HAGW
In previous versions of this module, the HAGW was deployed in the incorrect subnet in AWS. Updating to this version rectifies that. As the HAGW needs to be redeployed, there is a chance of impact to network traffic.
It is strongly advised to upgrade and rectify this issue however, as having the HAGW in the wrong subnet results in both gateways using the same availability zone. An availability zone outage could therefore take out both gateways at once.

## v1.1.1

### Add support for controller version 6.6.5404 and up and provider version 2.21.1.
This version supports the new 6.6.5404 features and works with the provider version 2.21.1-6.6-ga

### Add support for enable_active_standby_preemptive
With release 6.6.5404 this feature was introduced. More details can be found [here](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/guides/release-notes#enable_active_standby_preemptive).