[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseBOMForUnicodeEncodedFile', '')]
Param()

Describe "Subnet Private Link Service Network Policies" {
    Context "Subnet Private Link Service Network Policies" {

        BeforeAll {
            Connect-AzCli

            $rgName = "rg-iast-euw-kitchen-subnet-private-link-service"
            $vnetName = "vnet-iast-euw-kitchen-subnet-private-link-service"
            $subnetName = "kitchen-subnet"
            $subnet = az network vnet subnet show --name $subnetName --vnet-name $vnetName --resource-group $rgName | ConvertFrom-Json
        }

        It "Subnet enforce private link service network policies should be enabled" {
            $subnet.privateEndpointNetworkPolicies | Should -Be "Enabled"
        }

        It "Subnet enforce private link endpoint network policies should be disabled" {
            $subnet.privateLinkServiceNetworkPolicies | Should -Be "Disabled"
        }
    }
}
