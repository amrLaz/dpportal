# ias-subnet

Deploys Inox@Scale compliant subnet using ARM template.

Subnets, on Inox@Scale, **must be** deployed with a *Network Security Group* **AND** a *Route Table* attached.
`CD-DenySubnetWoNsg-Vnet` and/or `CD-DenySubnetWoUdr-Vnet` Azure Policies will be triggered if a non-compliant subnet is deployed.

[**azurerm**](https://registry.terraform.io/providers/hashicorp/azurerm/latest) Terraform provider's resources to deploy such resources (subnet, network security group, and route table) require to use `_association`-type resources which doesn't work with configured Azure Policies.
See [`azurerm_subnet_route_table_association`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) or [`azurerm_subnet_network_security_group_association`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) resources.

## Usage

See [main.tf](./examples/basic-example/main.tf) basic example or see module's documentation below.

## Limitations / Quirks

Couple limitations/quirks of ARM template deployment to have in mind versus _native_ `azurerm_subnet` Terraform resource:

- Terraform tracking of resources' lifecycle when deployed through an ARM template is not possible (it only tracks the ARM deployment resource in Azure, not the actual subnet resource). Therefore, it's recommended to explicitely declare the relationship between this module and resources deployed in the subnet with `depends_on` (e.g. `depends_on = [module.subnet]`).
- In case of **initial** deployment failure of ARM template, Terraform won't be able to track `azurerm_resource_group_template_deployment` resource in its state. Deployment should be deleted manually in Azure Portal or with `az cli`, before running `apply` again.
- Per `azurerm_resource_group_template_deployment` resource [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment), the resource will **atempt** to delete resources deployed by the ARM Template when it is deleted.
In rare cases, deployment is deleted but the resources aren't. Resources should be deleted manually in Azure Portal or with `az cli`.
- Parallel actions on the same resource is not supported by ARM template deployments. If creating multiple subnets in the same VNET with this module _at the same time_ (same \_layer\_/folder for example), you need to explicitely set `depends_on` attribute on ALL the modules' references, to force Terraform to deploy subnet in sequence. See example below:

```hcl
module "subnet_a" {
  # <module source and inputs>
}

module "subnet_b" {
  # <module source and inputs>

  depends_on = [module.subnet_a]
}

module "subnet_c" {
  # <module source and inputs>

  depends_on = [module.subnet_a, module.subnet_b]
}
```

## Tests

To test this module you have to :

- setup test environment vars: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID` and `ARM_SUBSCRIPTION_ID`
- run `pip install -r requirements.txt` to install python dependencies
- run `bundle install` to install ruby dependencies
- run `bundle exec kitchen converge` to deploy test module
- run `bundle exec kitchen verify` to run module tests
- run `bundle exec kitchen destroy` to destroy test module

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group_template_deployment.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefix"></a> [address\_prefix](#input\_address\_prefix) | Subnet's IPv4 address prefix in CIDR notation (e.g. 10.0.0.0/16) | `string` | n/a | yes |
| <a name="input_delegations"></a> [delegations](#input\_delegations) | List of services to delegate subnet to | `list(string)` | `[]` | no |
| <a name="input_enforce_private_link_endpoint_network_policies"></a> [enforce\_private\_link\_endpoint\_network\_policies](#input\_enforce\_private\_link\_endpoint\_network\_policies) | Enable or disable network policies for the private link endpoint on the subnet. Conflicts with 'enforce\_private\_link\_service\_network\_policies' | `bool` | `false` | no |
| <a name="input_enforce_private_link_service_network_policies"></a> [enforce\_private\_link\_service\_network\_policies](#input\_enforce\_private\_link\_service\_network\_policies) | Enable or disable network policies for the private link service on the subnet. Conflicts with 'enforce\_private\_link\_endpoint\_network\_policies' | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Subnet's name | `string` | n/a | yes |
| <a name="input_nsg_id"></a> [nsg\_id](#input\_nsg\_id) | Network security group's id (e.g. /subscriptions/<sub\_id>/resourceGroups/<rg\_name>/providers/Microsoft.Network/networkSecurityGroups/<nsg\_name>) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group's name is which subnet will be deployed. | `string` | n/a | yes |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | Route table's name that will be attached to the deployed subnet. | `string` | `""` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | List of service endpoints to associate with the subnet | `list(string)` | `[]` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Virtual network's name where subnet will be deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Subnet's id |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Subnet's name |
