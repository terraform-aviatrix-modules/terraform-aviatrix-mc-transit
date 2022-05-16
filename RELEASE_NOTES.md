# terraform-aviatrix-mc-transit release notes

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