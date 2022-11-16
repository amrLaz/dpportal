<#
.SYNOPSIS
Connect to a subscription using environment variables
.DESCRIPTION
Connect to a subscription using environment variables
.EXAMPLE
Connect-TestSubscription
.NOTES
#>
function Connect-AzCli {
  $clientId = $env:ARM_CLIENT_ID
  $clientSecret = $env:ARM_CLIENT_SECRET
  $tenantId = $env:ARM_TENANT_ID

  az login --username $clientId --password $clientSecret --service-principal --tenant $tenantId
  az account set --subscription $env:ARM_SUBSCRIPTION_ID
}

Export-ModuleMember -Function Connect-AzCli