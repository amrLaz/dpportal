Import-Module Pester

$WarningPreference = 'SilentlyContinue'

Import-Module ./test/integration/loginHelper.psm1

$configuration = [PesterConfiguration]@{
  Output = @{ Verbosity = "Detailed" };
  Run    = @{ Path = "./test/integration/without-route-table"; Exit = $true }
}
Invoke-Pester -Configuration $configuration