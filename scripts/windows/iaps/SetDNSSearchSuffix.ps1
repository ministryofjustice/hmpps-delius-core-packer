$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

# To simplify oracle client config by using hostname values only, 
# add this environment's internal r53 zone suffix to the global search list at runtime

try {
    if ( (Get-ScheduledJob -Name UpdateDNSSearchSuffix | Measure-Object).Count -eq 0 ) {
        Write-Host ('Creating DNS SearchSuffix Run Once Job')
        $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
        Register-ScheduledJob -Trigger $trigger -FilePath C:\Setup\SetDNSSearchSuffix.ps1 -Name UpdateDNSSearchSuffix
        Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name UpdateDNSSearchSuffix -Value C:\Setup\SetDNSSearchSuffix.ps1
    } else {
        Write-Host ('Existing trigger job found.')
    }
}
catch {}

# Create a startup job to update dns search suffix with internal domain name
try {
    # Get the instance id from ec2 meta data
    $instanceid = Invoke-WebRequest -Uri http://169.254.169.254/latest/meta-data/instance-id | Select-Object -ExpandProperty Content
    # Get the environment name from this instance's environment-name tag value
    $environment = aws ec2 describe-tags --region eu-west-2 --filters "Name=resource-id,Values=$instanceid","Name=key,Values=environment-name" --query 'Tags[0].Value' --output text
    # Add the internal hosted zone suffix to the existing list - if tagged correctly, ie not build env
    if ($environment -like "*none*") {
        Write-Host('Skipping DNS Suffix Update as no environment-tag exists')
    } else {
        $dnsconfig = Get-DnsClientGlobalSetting
        if ($dnsconfig.SuffixSearchList -match $environment) {
            Write-Host('Skipping DNS Search Suffix as matching entry exists')
        } else {
            Write-Host('Adding DNS Search Suffix Entry')
            $dnsconfig.SuffixSearchList += "$environment.internal"
            Set-DnsClientGlobalSetting -SuffixSearchList $dnsconfig.SuffixSearchList
            Clear-DnsClientCache
        }
    }
}
catch [Exception] {
    Write-Host ('Failed to Update DNS Search Suffix List')
    echo $_.Exception|format-list -force
    exit 1
}