# To simplify oracle client config by using hostname values only, 
# add this environment's internal r53 zone suffix to the global search list at runtime

# Create a startup job to update dns search suffix with internal domain name
if ( (Get-ScheduledJob -Name UpdateDNSSearchSuffix | Measure-Object).Count -eq 0 ) {
    $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
    Register-ScheduledJob -Trigger $trigger -FilePath C:\Setup\SetDNSSearchSuffix.ps1 -Name UpdateDNSSearchSuffix
}

# Get the instance id from ec2 meta data
$instanceid = Invoke-WebRequest -Uri http://169.254.169.254/latest/meta-data/instance-id | Select-Object -ExpandProperty Content
# Get the environment name from this instance's environment-name tag value
$environment = aws ec2 describe-tags --region eu-west-2 --filters "Name=resource-id,Values=$instanceid","Name=key,Values=environment-name" --query 'Tags[0].Value' --output text
# Add the internal hosted zone suffix to the existing list
$dnsconfig = Get-DnsClientGlobalSetting
$dnsconfig.SuffixSearchList += "$environment.internal"
Set-DnsClientGlobalSetting -SuffixSearchList $dnsconfig.SuffixSearchList
Clear-DnsClientCache