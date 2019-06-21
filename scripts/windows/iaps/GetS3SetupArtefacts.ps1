$ErrorActionPreference = "Stop"
$VerbosePreference="Continue"

$keyPrefix = "IAPS/"
# The local file path where files should be copied
$localPath = "C:\Setup\"
# Debug
Get-ChildItem env:
Read-S3Object -BucketName $env:ARTIFACT_BUCKET -KeyPrefix $keyPrefix -Folder $localPath

if( (Get-ChildItem $localPath | Measure-Object).Count -eq 0)
{
    echo "Error: Local Artefact Directory is empty"
    exit 1
}