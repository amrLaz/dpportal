variable "vnet_name" {
  type        = string
  description = "Virtual network's name where subnet will be deployed."
}

variable "name" {
  type        = string
  description = "Subnet's name"
}

variable "address_prefix" {
  type        = string
  description = "Subnet's IPv4 address prefix in CIDR notation (e.g. 10.0.0.0/16)"

  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(\\d|[1-2]\\d|3[0-2]))$", var.address_prefix))
    error_message = "The 'address_prefix' value must be a valid IPv4 in CIDR notation (e.g. 10.0.0.0/16)."
  }
}

variable "service_endpoints" {
  type        = list(string)
  default     = []
  description = "List of service endpoints to associate with the subnet"
}

variable "delegations" {
  type        = list(string)
  default     = []
  description = "List of services to delegate subnet to"
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  default     = false
  description = "Enable or disable network policies for the private link endpoint on the subnet. Conflicts with 'enforce_private_link_service_network_policies'"
}

variable "enforce_private_link_service_network_policies" {
  type        = bool
  default     = false
  description = "Enable or disable network policies for the private link service on the subnet. Conflicts with 'enforce_private_link_endpoint_network_policies'"
}

variable "nsg_id" {
  type        = string
  description = "Network security group's id (e.g. /subscriptions/<sub_id>/resourceGroups/<rg_name>/providers/Microsoft.Network/networkSecurityGroups/<nsg_name>)"

  validation {
    condition     = can(regex("^\\/subscriptions\\/[\\w-]+\\/resourceGroups\\/[\\w-]+\\/providers\\/Microsoft.Network\\/networkSecurityGroups\\/[\\w-]+$", var.nsg_id))
    error_message = "The nsg_id value must be a valid ARM Network Security Group resource id."
  }
}

variable "route_table_name" {
  type        = string
  description = "Route table's name that will be attached to the deployed subnet."
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "Resource group's name is which subnet will be deployed."
}
