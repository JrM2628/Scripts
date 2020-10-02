#Jake McLellan
#CSEC 464 - Computer System Forensics 
#Lab #01 – Incident Response - Windows Edition
#
#Uglier than my Bash script, but nearly all functionality is maintained!
#

#Time
echo "**Current system time"; 
Get-Date;
echo "**PC Uptime"; 
((Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime).ToString()

#OS Version
echo "**CPU Info";
Get-WmiObject Win32_Processor;
echo "**Windows Version"
[System.Environment]::OSVersion;
echo "**OS Typical Name"
$pcInfo = Get-ComputerInfo;
$pcInfo.OsName;

#System specs
echo "**CPU Architecture information";
$pcInfo.OsArchitecture;
echo "**Total Physical Memory";
$pcInfo.CsTotalPhysicalMemory/1GB
echo "**Used Virtual Memory";
$pcInfo.OsInUseVirtualMemory;
echo "**Free Virtual Memory";
$pcInfo.OsFreeVirtualMemory;
echo "**File system disk usage and partitions";
Get-Disk | Format-Table;
Get-Partition | Format-Table;
echo "**Hostname";
$pcInfo.CsDNSHostName;
echo "**Domain name";
$pcInfo.CsDomain;

#Network
echo "**IP Addresses";
(Get-NetIPAddress).IPAddress;
echo "**MAC Addresses";
(Get-NetAdapter).MacAddress;
echo "**Devices in promiscuous mode";
Get-NetAdapter | Where-Object {$_.PromiscuousMode -eq $true};
echo "**Network connections";
netstat -ano

#Users
#Closest thing I could get to currently logged in users
echo "**Logged in users";
(Get-WmiObject Win32_LoggedOnUser) | Select Antecedent -Unique;
echo "**Administrator group users"
Get-LocalGroupMember -Group Administrators;

#Processes and open files
    #No way to get the opened files/handles without sysinternals 
echo "**Currently Running Processes";
Get-Process | Format-Table;

#Other misc
$homedir = Get-Variable -Name HOME;
$1day = (Get-Date).AddDays(-1);
echo "**Files in home directory modified in the last day";
Get-ChildItem -Path $homedir.Value -Recurse | Where-Object {$_.LastWriteTime -gt $1day};
echo "**Scheduled tasks executed by SYSTEM";
(Get-ScheduledTask) | Where-Object {$_.Principal.UserID -eq "SYSTEM"} | Format-Table;
echo "**Loaded DLLs";
tasklist /M;