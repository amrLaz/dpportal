module "private-link-endpoint-network-policies" {
  source = "../../"

  resource_group_name = azurerm_resource_group.self.name
  nsg_id              = azurerm_network_security_group.self.id
  route_table_name    = azurerm_route_table.self.name
  vnet_name           = azurerm_virtual_network.self.name

  name           = "kitchen-subnet"
  address_prefix = "10.0.0.0/16"

  enforce_private_link_endpoint_network_policies = true

  depends_on = [
    azurerm_virtual_network.self,
    azurerm_network_security_group.self,
    azurerm_route_table.self
  ]
}
