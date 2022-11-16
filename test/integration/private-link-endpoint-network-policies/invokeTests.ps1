Import-Module Pester

$WarningPreference = 'SilentlyContinue'

Import-Module ./test/integration/loginHelper.psm1

$configuration = [PesterConfiguration]@{
  Output = @{ Verbosity = "Detailed" };
  Run    = @{ Path = "./test/integration/private-link-endpoint-network-policies"; Exit = $true }
}
Invoke-Pester -Configuration $configuration