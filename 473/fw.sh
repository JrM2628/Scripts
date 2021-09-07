# Jake McLellan 
# HW1 - Firewalls
# Linux firewall deployment script

# Flush default rules to clean things up
iptables -F


# INBOUND RULES
#
#
# ICMP
iptables --append INPUT --protocol icmp --icmp-type any --jump ACCEPT
# HTTP(S)
iptables --append INPUT --protocol tcp --dport 80 --jump ACCEPT
iptables --append INPUT --protocol tcp --dport 443 --jump ACCEPT
# SSH
iptables --append INPUT --protocol tcp --dport 22 --jump ACCEPT
# Drop packets that don't match a rule
iptables -P INPUT DROP


# OUTBOUND RULES
#
#
# ICMP 
iptables --append OUTPUT --protocol icmp --icmp-type any --jump ACCEPT
# DNS
# Assuming 192.168.1.1 is the DNS server
iptables --append OUTPUT --protocol udp --dst 192.168.1.1 --dport 53 --jump ACCEPT
iptables --append OUTPUT --protocol tcp --dst 192.168.1.1 --dport 53 --jump ACCEPT
# HTTP(S)
iptables --append OUTPUT --protocol tcp --dport 80 --jump ACCEPT
iptables --append OUTPUT --protocol tcp --dport 443 --jump ACCEPT
# LDAP(S)
iptables --append OUTPUT --protocol tcp --dport 389 --jump ACCEPT
iptables --append OUTPUT --protocol tcp --dport 636 --jump ACCEPT

# Drop packets that don't match a rule
iptables -P OUTPUT DROP
