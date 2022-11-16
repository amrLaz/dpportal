module "without-route-table" {
  source = "../../"

  resource_group_name = azurerm_resource_group.self.name
  nsg_id              = azurerm_network_security_group.self.id
  vnet_name           = azurerm_virtual_network.self.name

  name           = "direct-kitchen-subnet"
  address_prefix = "10.0.0.0/16"

  depends_on = [
    azurerm_virtual_network.self,
    azurerm_network_security_group.self
  ]
}
