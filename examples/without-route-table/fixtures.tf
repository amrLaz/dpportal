resource "azurerm_resource_group" "self" {
  name     = "rg-iast-euw-kitchen-subnet-wo-route-table"
  location = "westeurope"
}

resource "azurerm_virtual_network" "self" {
  name                = "vnet-iast-euw-kitchen-subnet-wo-route-table"
  location            = azurerm_resource_group.self.location
  resource_group_name = azurerm_resource_group.self.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "self" {
  name                = "nsg-iast-euw-kitchen-subnet-wo-route-table"
  resource_group_name = azurerm_resource_group.self.name
  location            = azurerm_resource_group.self.location

  security_rule {
    name                       = "allow-inbound-kitchen"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
