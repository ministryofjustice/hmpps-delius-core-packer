# Security Groups will be used to apply CIDR based restrictions
# Inbound Rules
New-NetFirewallRule -DisplayName "Allow Inbound Port 80" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 443" -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow

# Outbound Rules
New-NetFirewallRule -DisplayName "Allow Outbound Port 80" -Direction Outbound -RemotePort 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Outbound Port 443" -Direction Outbound -RemotePort 443 -Protocol TCP -Action Allow