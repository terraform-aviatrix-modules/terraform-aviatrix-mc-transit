# terraform-aviatrix-mc-transit release notes

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