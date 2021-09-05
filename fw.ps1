#Firewall
#-------------------------------------------------------------------------------------------------------
Get-service -DisplayName “*firew*” | Set-Service -StartupType Automatic
Get-service -DisplayName “*firew*” | Start-Service

#FW Logs
Get-NetFirewallProfile -All | Set-NetFirewallProfile -LogFileName %systemroot%\firewall.log
Get-NetFirewallProfile -All | Set-NetFirewallProfile -LogMaxSizeKilobytes 32767
Get-NetFirewallProfile -All |Set-NetFirewallProfile -LogBlocked True
Get-NetFirewallProfile -All |Set-NetFirewallProfile -LogAllowed True

#FW Profiles disabled except domain
Get-NetFirewallProfile -Name Domain | Set-NetFirewallProfile -Enabled True
Get-NetFirewallProfile -All | Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Block 
Remove-NetFirewallRule

$baserule = "New-NetFirewallRule -Action Allow -Profile Domain -DisplayName '{0}' -Protocol {1} -LocalPort {2} -Program {3}"
$baserulesvc = "New-NetFirewallRule -Action Allow -Profile Domain -DisplayName '{0}' -Protocol {1} -LocalPort {2} -Program %systemroot%\System32\svchost.exe -Service {3}"

Invoke-Expression ([string]::Format($baserule, "LDAP In TCP", "TCP", "389", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "LDAP In UDP", "UDP", "389", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "LDAP Global Catalog In", "TCP", "3268", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "NetBIOS Name Resolution In", "UDP", "138", "System"))
Invoke-Expression ([string]::Format($baserule, "SMB In TCP", "TCP", "445", "System"))
Invoke-Expression ([string]::Format($baserule, "SMB In UDP", "UDP", "445", "System"))
Invoke-Expression ([string]::Format($baserule, "Secure LDAP In", "TCP", "636", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Secure LDAP Global Catalog In", "TCP", "3269", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserulesvc, "W32Time In", "UDP", "123", "w32time"))
Invoke-Expression ([string]::Format($baserule, "Kerberos In TCP", "TCP", "88", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Kerberos In UDP", "UDP", "88", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Kerberos PCR In TCP", "TCP", "464", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Kerberos PCR In UDP", "UDP", "464", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserulesvc, "DNS In", "TCP", "53", "dns"))
Invoke-Expression ([string]::Format($baserulesvc, "DHCP In", "UDP", "68 -RemotePort 67", "dhcp"))
Invoke-Expression ([string]::Format($baserule, "RPC In", "TCP", "RPC", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserulesvc, "RPCSs In", "TCP", "RPCEPMap", "rpcss"))

$baserule = "New-NetFirewallRule -Action Allow -Direction Outbound -Profile Domain -DisplayName '{0}' -Protocol {1} -LocalPort {2} -Program {3}"
$baserulesvc = "New-NetFirewallRule -Action Allow -Direction Outbound -Profile Domain -DisplayName '{0}' -Protocol {1} -LocalPort {2} -Program %systemroot%\System32\svchost.exe -Service {3}"
Invoke-Expression ([string]::Format($baserulesvc, "DNS Out", "UDP", "53", "dnscache"))
