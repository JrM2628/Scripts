# Jake McLellan 
# HW1 - Firewalls
# Windows firewall test script

$ErrorActionPreference= ‘silentlycontinue’

# Default placeholder value for IP 
$ip="192.168.1.1";
# List of ports to scan
$ports = (53,88,389,445,464,636,3268,3269)

# Check if ICMP inbound connections are working
if (Test-Connection –BufferSize 32 –Count 1 –Quiet –ComputerName $ip) {
	# For each port, attempt to create a TCP connection
	foreach ($port in $ports){
		$socket = New-Object System.Net.Sockets.TcpClient($ip, $port)
		# Print success or failure message depending on connection status
		if ($socket.Connected) { 
			“$ip port $port open”
			$socket.Close() 
		}
		else { 
			“$ip port $port closed” 
		}
	}
}