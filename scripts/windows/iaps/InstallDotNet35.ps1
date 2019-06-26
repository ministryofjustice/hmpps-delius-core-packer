$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

try {
    Write-Host('Installing DotNet3.5')
    Write-Host('Installing NDelius Interface Package')
    Start-Process -Wait -FilePath "C:\Setup\Source Files\dotnetfx35.exe" -ArgumentList "/quiet /qn" -Verb RunAs

}
catch [Exception] {
    Write-Host ('Failed to enable .Net3.5 Windows Feature')
    echo $_.Exception|format-list -force
    exit 1
}