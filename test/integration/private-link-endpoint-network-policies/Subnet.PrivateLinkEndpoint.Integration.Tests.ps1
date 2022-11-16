[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseBOMForUnicodeEncodedFile', '')]
Param()

Describe "Subnet Private Link Endpoint Network Policies" {
    Context "Subnet Private Link Endpoint Network Policies" {

        BeforeAll {
            Connect-AzCli

            $rgName = "rg-iast-euw-kitchen-subnet-private-link-endpoint"
            $vnetName = "vnet-iast-euw-kitchen-subnet-private-link-endpoint"
            $subnetName = "kitchen-subnet"
            $subnet = az network vnet subnet show --name $subnetName --vnet-name $vnetName --resource-group $rgName | ConvertFrom-Json
        }

        It "Subnet enforce private link service network policies should be disabled" {
            $subnet.privateEndpointNetworkPolicies | Should -Be "Disabled"
        }

        It "Subnet enforce private link endpoint network policies should be enabled" {
            $subnet.privateLinkServiceNetworkPolicies | Should -Be "Enabled"
        }
    }
}
