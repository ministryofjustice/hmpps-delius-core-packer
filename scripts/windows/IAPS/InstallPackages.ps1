# Chocolatey installed on base image

# vcredist packages
choco install -y vcredist2010
choco install -y vcredist2008

# nginx proxy as a service
choco install -y nginx-service --version 1.16.0

# Firefox browser
choco install -y firefox --version 67.0.3