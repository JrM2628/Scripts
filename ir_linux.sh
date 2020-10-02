#!/bin/bash
#Jake McLellan 
#Computer System Forensics
#Lab 1: Incident Response 
#


function echoHeader {
	echo -e "\e[103m\e[30m" $1 "\e[39m\e[49m";
}

function echoRed {
	echo -e "\e[31m" $1 "\e[39m"
}

#1. Time
function getTime {
	echoHeader "Time";
	echoRed "Current system date/time/timezone";
	date;
	echoRed "PC Uptime";
	uptime;
}


#2. OS Version
function getOSVersion {
	echoHeader "OS Version";
	echoRed "CPU Info";
	cat /proc/cpuinfo;
	echoRed "OS Typical Name";
	cat /etc/os-release  | grep PRETTY_NAME= | cut -d"\"" -f2;
	echoRed "Kernel Version"; 
	uname --kernel-release;
}


#3. System Specs
	function getSystemSpecs {
	echoHeader "System Specs";
	echoRed "CPU architecture information";
	uname --operating-system --processor;
	echoRed "Amount of free and used physical memory";
	free -ht;
	echoRed "File system disk usage and partitions";
	df -h;
	echo 
	lsblk -a;
	echo 
	echoRed "Hostname and domainname";
	hostname;
	domainname;
}


#4. Network
function getNetworkInfo {
	echoHeader "Network Info";
	echoRed "IP Addresses";
	ip addr show;
	echoRed "Searching for interfaces in promiscuous mode...";
	ip a | grep PROMISC;
	echoRed "MAC Addresses for all interfaces";
	cat /sys/class/net/*/address;
	echoRed "Established network connections";
	ss -n state established;
	echoRed "Listening sockets along with process";
	ss -lutnp;
}


#5. Users
function getUserInfo {
	echoHeader "Users";
	echoRed "Logged in users";
	who;
	echoRed "All users on system";
	cut -d: -f1 /etc/passwd;
	
	echoRed "All users with uid=0";
	filename='/etc/passwd'
	while read line; do
			uid=$(echo $line | cut -f 3 -d:);
			if [ "$uid" -eq "0" ]
			then
					echo $line;
			fi
	done < $filename

	echoRed "All root-owned SUID files";
	find / -uid 0 -perm 4000 2>/dev/null
}

#6. Processes and Open Files
function getProcessInfo {
	echoHeader "Processes and Open Files";
	echoRed "All running processes";
	ps -aux; 
	echoRed "All files opened by nc";
	lsof -c nc;
	echoRed "All opened, but unlinked files";
	lsof +L1;
}


#7. Other miscellaneous 
function getMiscInfo {
	echoHeader "Other miscellaneous information"
	echoRed "All files in home directory modified in last day";
	find ~ -mtime -1;
	echoRed "Scheduled tasks for root (must run with sudo)";
	crontab -l -u root;

	#Now here's my 3
	echoRed "Kernel Modules";
	cat /proc/modules 2>/dev/null;
	echoRed "ARP table";
    	arp -vn;
	echoRed "Loaded Libraries (Wall of text incoming)";
	cat /proc/*/maps 2>/dev/null | uniq;
}

function callAll {
	getTime;
	getOSVersion;
	getSystemSpecs;
	getNetworkInfo;
	getUserInfo;
	getProcessInfo;
	getMiscInfo;
}



#Main 
while :
do
	echo 
	echo ----------------------
	echo 
	echo "Make your selection"
	echo "1. Time"
	echo "2. OS Version"
	echo "3. System Specs"
	echo "4. Network"
	echo "5. Users"
	echo "6. Processes and Open Files"
	echo "7. Other miscellaneous"
	echo "8. All information"
	echo "9. Exit"
	read -p "Make your selection [1-9]: " choice
	case $choice in 
		1) getTime;; 
		2) getOSVersion;;
		3) getSystemSpecs;;
		4) getNetworkInfo;;
		5) getUserInfo;;
		6) getProcessInfo;;
		7) getMiscInfo;; 
		8) callAll;;
		9) exit 0;;
		*) echoRed "Running all modules and exiting"; callAll; exit 0;;
	esac
done
