[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseBOMForUnicodeEncodedFile', '')]
Param()

Describe "Subnet Basic Example" {
    Context "Subnet Basic Example" {

        BeforeAll {
            Connect-AzCli

            $rgName = "rg-iast-euw-kitchen-subnet"
            $vnetName = "vnet-iast-euw-kitchen-subnet"
            $subnetName = "kitchen-subnet"
            $subnet = az network vnet subnet show --name $subnetName --vnet-name $vnetName --resource-group $rgName | ConvertFrom-Json

            $nsgName = "nsg-iast-euw-kitchen-subnet"
            $nsg = az network nsg show --name $nsgName --resource-group $rgName | ConvertFrom-Json

            $udrName = "udr-iast-euw-kitchen-subnet"
            $udr = az network route-table show --name $udrName --resource-group $rgName | ConvertFrom-Json
        }

        It "Subnet address prefix should be correct" {
            $subnet.addressPrefix | Should -Be "10.0.0.0/16"
        }

        It "Subnet service endoints should be correct" {
            $subnet.serviceEndpoints[0].service | Should -Be "Microsoft.KeyVault"
            $subnet.serviceEndpoints[1].service | Should -Be "Microsoft.Storage"
        }

        It "Subnet service delegations should be correct" {
            $subnet.delegations[0].serviceName | Should -Be "Microsoft.Web/serverFarms"
        }

        It "Subnet enforce private link service network policies should be disabled" {
            $subnet.privateEndpointNetworkPolicies | Should -Be "Disabled"
        }

        It "Subnet enforce private link endpoint network policies should be disabled" {
            $subnet.privateLinkServiceNetworkPolicies | Should -Be "Disabled"
        }

        It "Subnet should have a NSG" {
            $subnet.networkSecurityGroup.id | Should -Be $nsg.id
        }

        It "Subnet should have a UDR" {
            $subnet.routeTable.id | Should -Be $udr.id
        }
    }
}
