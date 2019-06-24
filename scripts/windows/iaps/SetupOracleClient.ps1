# Extract setup files from 7z archive
New-Item -Path "C:\Setup\Oracle" -Name "Install" -ItemType "directory"
Start-Process "$env:ProgramFiles\7-Zip\7z.exe" "x -oC:\Setup\Oracle\Install C:\Setup\Oracle\Oracle_12c_Win32_12.1.0.2.0.7z"

# Add required patches for x86 client
# Edit oaparam file to use 32bit vcredist
$oaparamfile = "C:\Setup\Oracle\Install\Oracle_12c_Win32_12.1.0.2.0\client32\install\oraparam.ini"
if (Test-Path -Path $oaparamfile) {
    ((Get-Content -path $oaparamfile -Raw) -replace 'MSVCREDIST_LOC=vcredist_x64.exe','MSVCREDIST_LOC=vcredist_x86.exe') | Set-Content -Path $oaparamfile 
} else {
    write-host("Error - could not find oracle setup param file: $oaparamfile")
    exit 1
}

# Create x86 reg entry
Push-Location
Set-Location HKLM:
New-Item -Path .\SOFTWARE\Wow6432Node -Name ORACLE -Type Directory –Force
New-Itemproperty -Path .\SOFTWARE\Wow6432Node\ORACLE -Name 'inst_loc' -Value 'C:\Program Files (x86)\Oracle\Inventory' -PropertyType "String"
Pop-Location

# Install 32bit client from answer file, using runas administrator verb
# See: https://docs.oracle.com/database/121/NTCLI/advance.htm#NTCLI1347
$oracleanswerfile = "C:\Setup\Oracle\OracleClient.rsp"
Start-Process -FilePath "C:\Setup\Oracle\Install\Oracle_12c_Win32_12.1.0.2.0\client32\setup.exe" -Verb RunAs "ORACLE_HOSTNAME=$env:computername" -ArgumentList "-silent -nowelcome -nowait -noconfig -responseFile $oracleanswerfile" 
# Configure net connections
$tnsnameorafile = "C:\app\client\Administrator\product\12.1.0\client_1\network\admin\tnsnames.ora"
Move-Item "$tnsnameorafile" -Destination "$tnsnameorafile.orig" -Force
Copy-Item "C:\Setup\Oracle\tnsnames.ora.tmpl" -Destination "$tnsnameorafile"