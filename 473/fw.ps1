# Jake McLellan 
# HW1 - Firewalls
# Windows firewall deployment script

# Firewall
#-------------------------------------------------------------------------------------------------------
# Get service and set it to automatically start if it isn't already
$fwsvc = Get-service -Name mpssvc 
if($fwsvc.StartType -ne 'Automatic'){
    Set-Service $fwsvc -StartupType Automatic
}

# Set up fw logging
Get-NetFirewallProfile -All | Set-NetFirewallProfile -LogFileName %systemroot%\firewall.log
Get-NetFirewallProfile -All | Set-NetFirewallProfile -LogMaxSizeKilobytes 32767
Get-NetFirewallProfile -All |Set-NetFirewallProfile -LogBlocked True
Get-NetFirewallProfile -All |Set-NetFirewallProfile -LogAllowed True

# FW Profiles disabled except domain, default rule set to block 
Get-NetFirewallProfile -Name Domain | Set-NetFirewallProfile -Enabled True
Get-NetFirewallProfile -All | Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Block 
Remove-NetFirewallRule

# Base inbound rule templates
$baserule = "New-NetFirewallRule -Action Allow -Profile Domain -DisplayName '{0}' -Protocol {1} -LocalPort {2} -Program {3}"
$baserulesvc = "New-NetFirewallRule -Action Allow -Profile Domain -DisplayName '{0}' -Protocol {1} -LocalPort {2} -Program %systemroot%\System32\svchost.exe -Service {3}"
$baseruleicmp = "New-NetFirewallRule -Action Allow -Profile Domain -DisplayName '{0}' -Protocol {1}"

# ICMP in
Invoke-Expression ([string]::Format($baseruleicmp, "ICMP In", "ICMPv4"))
# LDAP/GC in
Invoke-Expression ([string]::Format($baserule, "LDAP In TCP", "TCP", "389", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "LDAP In UDP", "UDP", "389", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "LDAP Global Catalog In", "TCP", "3268", "%systemroot%\System32\lsass.exe"))
# Netbios in
Invoke-Expression ([string]::Format($baserule, "NetBIOS Name Resolution In", "UDP", "138", "System"))
# SMB/Named pipes in
Invoke-Expression ([string]::Format($baserule, "SMB In TCP", "TCP", "445", "System"))
Invoke-Expression ([string]::Format($baserule, "SMB In UDP", "UDP", "445", "System"))
# LDAP(S)/GC in 
Invoke-Expression ([string]::Format($baserule, "Secure LDAP In", "TCP", "636", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Secure LDAP Global Catalog In", "TCP", "3269", "%systemroot%\System32\lsass.exe"))
# NTP in
Invoke-Expression ([string]::Format($baserulesvc, "W32Time In", "UDP", "123", "w32time"))
# Kerberos/Password change in
Invoke-Expression ([string]::Format($baserule, "Kerberos In TCP", "TCP", "88", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Kerberos In UDP", "UDP", "88", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Kerberos PCR In TCP", "TCP", "464", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserule, "Kerberos PCR In UDP", "UDP", "464", "%systemroot%\System32\lsass.exe"))
# DNS service and process in. Also requires RPC ports to function.
Invoke-Expression ([string]::Format($baserulesvc, "DNS SVC In TCP", "TCP", "53", "dns"))
Invoke-Expression ([string]::Format($baserulesvc, "DNS SVC In UDP", "UDP", "53", "dns"))
Invoke-Expression ([string]::Format($baserule, "DNS In TCP", "TCP", "53", "%systemroot%\System32\dns.exe"))
Invoke-Expression ([string]::Format($baserule, "DNS In UDP", "UDP", "53", "%systemroot%\System32\dns.exe"))
Invoke-Expression ([string]::Format($baserule, "RPC DNS In TCP", "TCP", "RPC", "%systemroot%\System32\dns.exe"))
# DHCP in
Invoke-Expression ([string]::Format($baserulesvc, "DHCP In", "UDP", "68 -RemotePort 67", "dhcp"))
# RPC/Ss in
Invoke-Expression ([string]::Format($baserule, "RPC In", "TCP", "RPC", "%systemroot%\System32\lsass.exe"))
Invoke-Expression ([string]::Format($baserulesvc, "RPCSs In", "TCP", "RPCEPMap", "rpcss"))

# Base outbound rule template
$baserule = "New-NetFirewallRule -Action Allow -Direction Outbound -Profile Domain -DisplayName '{0}' -Protocol {1} -RemotePort {2} -Program {3}"
$baserulesvc = "New-NetFirewallRule -Action Allow -Direction Outbound -Profile Domain -DisplayName '{0}' -Protocol {1} -RemotePort {2} -Program %systemroot%\System32\svchost.exe -Service {3}"
$baseruleicmp = "New-NetFirewallRule -Action Allow -Direction Outbound -Profile Domain -DisplayName '{0}' -Protocol {1}"

# ICMP out
Invoke-Expression ([string]::Format($baseruleicmp, "ICMP Out", "ICMPv4"))
# DNS server + client out
Invoke-Expression ([string]::Format($baserulesvc, "DNSCache Out UDP", "UDP", "53", "dnscache"))
Invoke-Expression ([string]::Format($baserulesvc, "DNSCache Out TCP", "TCP", "53", "dnscache"))
Invoke-Expression ([string]::Format($baserule, "DNS Out UDP", "UDP", "53", "%systemroot%\System32\dns.exe"))
Invoke-Expression ([string]::Format($baserule, "DNS Out TCP", "TCP", "53", "%systemroot%\System32\dns.exe"))
Invoke-Expression ([string]::Format($baserulesvc, "DNSSvc Out UDP", "UDP", "53", "dns"))
Invoke-Expression ([string]::Format($baserulesvc, "DNSSvc Out TCP", "TCP", "53", "dns"))
# DHCP client out
$dhcprule = "New-NetFirewallRule -Action Allow -Direction Outbound -Profile Any -DisplayName 'DHCP Client Out' -Service dhcp -Protocol UDP -LocalPort 68"
Invoke-Expression $dhcprule
# Browser out
$ffrule = "New-NetFirewallRule -Action Allow -Direction Outbound -Profile Domain -DisplayName 'Firefox Out' -Program 'C:\Program Files\Mozilla Firefox\firefox.exe' -Protocol TCP -RemotePort 80,443"
Invoke-Expression $ffrule