### Usage Example Azure HA

In this example, the module deploys the transit VNET as well as a HA pair of Aviatrix transit gateways.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "PIP-RG"
  location = "West Europe"
}

resource "azurerm_public_ip" "pip1" {
  name                = "PIP-TrGW"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
resource "azurerm_public_ip" "pip2" {
  name                = "PIP-TrGW-ha"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
```
