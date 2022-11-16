Import-Module Pester

$WarningPreference = 'SilentlyContinue'

Import-Module ./test/integration/loginHelper.psm1

$configuration = [PesterConfiguration]@{
  Output = @{ Verbosity = "Detailed" };
  Run    = @{ Path = "./test/integration/basic-example"; Exit = $true }
}
Invoke-Pester -Configuration $configuration