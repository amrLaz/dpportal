/**
 * # ias-subnet
 *
 * Deploys Inox@Scale compliant subnet using ARM template.
 *
 * Subnets, on Inox@Scale, **must be** deployed with a *Network Security Group* **AND** a *Route Table* attached.
 * `CD-DenySubnetWoNsg-Vnet` and/or `CD-DenySubnetWoUdr-Vnet` Azure Policies will be triggered if a non-compliant subnet is deployed.
 *
 * [**azurerm**](https://registry.terraform.io/providers/hashicorp/azurerm/latest) Terraform provider's resources to deploy such resources (subnet, network security group, and route table) require to use `_association`-type resources which doesn't work with configured Azure Policies.
 * See [`azurerm_subnet_route_table_association`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) or [`azurerm_subnet_network_security_group_association`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) resources.
 *
 * ## Usage
 *
 * See [main.tf](./examples/basic-example/main.tf) basic example or see module's documentation below.
 *
 * ## Limitations / Quirks
 *
 * Couple limitations/quirks of ARM template deployment to have in mind versus _native_ `azurerm_subnet` Terraform resource:
 *
 * - Terraform tracking of resources' lifecycle when deployed through an ARM template is not possible (it only tracks the ARM deployment resource in Azure, not the actual subnet resource). Therefore, it's recommended to explicitely declare the relationship between this module and resources deployed in the subnet with `depends_on` (e.g. `depends_on = [module.subnet]`).
 * - In case of **initial** deployment failure of ARM template, Terraform won't be able to track `azurerm_resource_group_template_deployment` resource in its state. Deployment should be deleted manually in Azure Portal or with `az cli`, before running `apply` again.
 * - Per `azurerm_resource_group_template_deployment` resource [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment), the resource will **atempt** to delete resources deployed by the ARM Template when it is deleted.
 * In rare cases, deployment is deleted but the resources aren't. Resources should be deleted manually in Azure Portal or with `az cli`.
 * - Parallel actions on the same resource is not supported by ARM template deployments. If creating multiple subnets in the same VNET with this module _at the same time_ (same _layer_/folder for example), you need to explicitely set `depends_on` attribute on ALL the modules' references, to force Terraform to deploy subnet in sequence. See example below:
 *
 * ```hcl
 * module "subnet_a" {
 *   # <module source and inputs>
 * }
 *
 * module "subnet_b" {
 *   # <module source and inputs>
 *
 *   depends_on = [module.subnet_a]
 * }
 *
 * module "subnet_c" {
 *   # <module source and inputs>
 *
 *   depends_on = [module.subnet_a, module.subnet_b]
 * }
 * ```
 *
 * ## Tests
 *
 * To test this module you have to :
 *
 * - setup test environment vars: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID` and `ARM_SUBSCRIPTION_ID`
 * - run `pip install -r requirements.txt` to install python dependencies
 * - run `bundle install` to install ruby dependencies
 * - run `bundle exec kitchen converge` to deploy test module
 * - run `bundle exec kitchen verify` to run module tests
 * - run `bundle exec kitchen destroy` to destroy test module
 */

resource "random_id" "id" {
  keepers = {
    subnet_name         = var.name
    resource_group_name = var.resource_group_name
  }

  byte_length = 2
}

resource "azurerm_resource_group_template_deployment" "subnet" {
  name = format("%s-%s", var.name, random_id.id.hex)

  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_content = templatefile("${path.module}/templates/subnet.json", {
    resource_group_name                          = var.resource_group_name
    route_table_name                             = var.route_table_name
    subnet_address_prefix                        = var.address_prefix
    subnet_private_link_service_network_policies = var.enforce_private_link_endpoint_network_policies ? "Enabled" : "Disabled"
    subnet_private_endpoint_network_policies     = var.enforce_private_link_service_network_policies ? "Enabled" : "Disabled"
    subnet_name                                  = var.name
    vnet_name                                    = var.vnet_name
  })

  parameters_content = jsonencode({
    serviceEndpoints = {
      value = var.service_endpoints
    }

    delegations = {
      value = var.delegations
    }

    networkSecurityGroupId = {
      value = var.nsg_id
    }
  })
  timeouts {
    create = "60m"
    read   = "60m"
  }
}
