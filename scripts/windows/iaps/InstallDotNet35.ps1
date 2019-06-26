$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

try {
    Write-Host('Installing DotNet3.5')
    Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All
}
catch [Exception] {
    Write-Host ('Failed to enable .Net3.5 Windows Feature')
    echo $_.Exception|format-list -force
    exit 1
}