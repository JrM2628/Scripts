#Download the goods and run
#The goods includes npp, sysinternals, git, firefox, and wireshark 
Invoke-WebRequest https://notepad-plus-plus.org/repository/7.x/7.0/npp.7.Installer.exe -o npp.exe
Invoke-WebRequest https://download.sysinternals.com/files/SysinternalsSuite.zip -o notsysinternals.zip
Expand-Archive notsysinternals.zip -DestinationPath ./abcdefghijklmnop/
cd abcdefghijklmnop
$filelist = Get-Item *
foreach($tempfile in $filelist){
    $newName = "not" + $tempfile.Name
    mv $tempfile $newName
}
cd ..
Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.26.2.windows.1/Git-2.26.2-64-bit.exe -o git.exe
Invoke-WebRequest "https://download.mozilla.org/?product=firefox-stub&os=win&lang=en-US" -o firefox.exe
Invoke-WebRequest https://2.na.dl.wireshark.org/win64/Wireshark-win64-3.2.3.exe -o wireshark.exe
wireshark.exe
firefox.exe
git.exe
npp.exe

#MBSA
start "https://www.microsoft.com/en-us/download/details.aspx?id=55319"

echo "YOU'RE NOT DONE YET. INSTALL EVERYTHING FIRST AND THEN HIT ENTER BECAUSE THE FIREWALL MAY SCREW WITH THE INSTALLATION PROCESS. RESET FIREWALL TO DEFAULT IF THIS HAPPENS."
pause

#Firewall
#-------------------------------------------------------------------------------------------------------
Get-service -DisplayName “*firew*” | Set-Service -StartupType Automatic
Get-service -DisplayName “*firew*” | Start-Service

#FW Logs
Get-NetFirewallProfile -All | Set-NetFirewallProfile -LogFileName %systemroot%\firewall.log
Get-NetFirewallProfile -All | Set-NetFirewallProfile -LogMaxSizeKilobytes 32767
Get-NetFirewallProfile -All |Set-NetFirewallProfile -LogBlocked True
Get-NetFirewallProfile -All |Set-NetFirewallProfile -LogAllowed True

Get-NetFirewallProfile -All | Set-NetFirewallProfile -Enabled True
#Get-NetFirewallProfile -All | Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Block 
#Remove-NetFirewallRule *
#EDIT RULES AS WE DEEM THEM NECESSARY


#auit
#--------------------------------------------------------
mkdir audit
schtasks.exe > audit\scheduledtasks.out          #gets all scheduled tasks
net user > audit\users.out                       #gets all users on box
net localgroup administrators >> audit\users.out


Get-Process | Format-Table > audit\procs.out     #gets all processes running
tasklist /m ws2_32.dll > audit\ws2Loaded.out     #gets all processes which have loaded the windows socket 2 dll (ie all that could use networking)
netstat -ano > audit\netstat.out                 #gets the current network usage
arp -av > audit\arp.out                          #gets the arp table
ipconfig /displaydns > audit\dnscache.out        #gets the DNS cache in case DNS is being used
sc query type=all > audit\servicesanddrivers.out #gets all the services and drivers
auditpol /get /category:* > audit\loggingauditpolicy.out
forfiles /p C:\ /M *.exe /S /D +1/1/2019 /C "cmd /c echo @fdate @ftime @path" 2> $null > audit\newexecutables.out #Finds executables written after January 2019

#Some basic hardening that *could* be useful. Add as you learn
Set-SmbServerConfiguration -EnableSMB1Protocol $false
Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope LocalMachine #This will make powershell scripts harder to run for both red and blue team. Use with caution. 
reg add "HKCU\ControlPanel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f #disable stickykeys
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v DisableLocalMachineRunOnce /t REG_DWORD /d 1 #Disable RunOnce
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v DisableLocalMachineRunOnce /t REG_DWORD /d 1
#Check if sethc.exe is backdoored
explorer.exe C:\Windows\System32\
#Add admin accounts to "Protected Users" group (requires Windows Server 2012 R2 Domain Controllers, 2012R2 DFL for domain protection). 
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git