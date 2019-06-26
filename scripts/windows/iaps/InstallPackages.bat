REM Chocolatey installed on base image

REM DotNet packages
choco install -y dotnet3.5 --version 3.5.20160716

REM vcredist packages
choco install -y vcredist2010
choco install -y vcredist2008

REM nginx proxy as a service
choco install -y nginx-service --version 1.16.0

REM Firefox browser
choco install -y firefox --version 67.0.3

REM 7Zip archive util
choco install -y 7zip.install --version 19.0