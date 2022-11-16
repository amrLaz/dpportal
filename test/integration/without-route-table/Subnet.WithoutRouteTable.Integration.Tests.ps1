[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseBOMForUnicodeEncodedFile', '')]
Param()

Describe "Subnet Without Route Table" {
    Context "Subnet Without Route Table" {

        BeforeAll {
            Connect-AzCli

            $rgName = "rg-iast-euw-kitchen-subnet-wo-route-table"
            $vnetName = "vnet-iast-euw-kitchen-subnet-wo-route-table"
            $subnetName = "direct-kitchen-subnet"
            $subnet = az network vnet subnet show --name $subnetName --vnet-name $vnetName --resource-group $rgName | ConvertFrom-Json

            $nsgName = "nsg-iast-euw-kitchen-subnet-wo-route-table"
            $nsg = az network nsg show --name $nsgName --resource-group $rgName | ConvertFrom-Json
        }

        It "Subnet address prefix should be correct" {
            $subnet.addressPrefix | Should -Be "10.0.0.0/16"
        }

        It "Subnet should have a NSG" {
            $subnet.networkSecurityGroup.id | Should -Be $nsg.id
        }

        It "Subnet should not have a UDR" {
            $subnet.routeTable.id | Should -Be $null
        }
    }
}
