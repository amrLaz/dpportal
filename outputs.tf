output "subnet_id" {
  description = "Subnet's id"
  value       = jsondecode(azurerm_resource_group_template_deployment.subnet.output_content).id.value
}

output "subnet_name" {
  description = "Subnet's name"
  value       = jsondecode(azurerm_resource_group_template_deployment.subnet.output_content).name.value
}
