$datadir="C:\Users\sli\Documents\Lab7\.data"
cd "$datadir\..\"
$dirlist=Get-ChildItem -Directory -Name;

Function compile{
    javac .\reversi\*.java .\reversi\server\*.java .\reversi\client\*.java
}
Function test1{
    $beforetime=Get-Date -UFormat %s;
    echo "Test 1 (10 pts)"
    echo "Attempting to generate 8x8"
    echo "==================================================================================="
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "java reversi.server.ReversiServer 8 50131; pause"
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "java reversi.client.ReversiClient localhost 50131; pause" 
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "java reversi.client.ReversiClient localhost 50131; pause"
    pause
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}

#Test 2 is considered in part1 function & code analysis

Function test3{
    $beforetime=Get-Date -UFormat %s;
    echo "Test 3 (5 pts)"
    echo "First player wins"
    echo "==================================================================================="
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "java reversi.server.ReversiServer 4 50133; pause"
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "cat $datadir\test3-1.txt | java reversi.client.ReversiClient localhost 50133; pause" 
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "cat $datadir\test3-2.txt | java reversi.client.ReversiClient localhost 50133; pause"
    pause
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
Function test4{
    $beforetime=Get-Date -UFormat %s;
    echo "Test 4 (5 pts)"
    echo "Second player wins"
    echo "==================================================================================="
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "java reversi.server.ReversiServer 4 50134; pause"
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "cat $datadir\test4-1.txt | java reversi.client.ReversiClient localhost 50134; pause" 
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "cat $datadir\test4-2.txt | java reversi.client.ReversiClient localhost 50134; pause"
    pause
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
Function test5{
    $beforetime=Get-Date -UFormat %s;
    echo "Test 5 (5 pts)"
    echo "Tied game"
    echo "==================================================================================="
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "java reversi.server.ReversiServer 4 50135; pause"
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "cat $datadir\test5-1.txt | java reversi.client.ReversiClient localhost 50135; pause" 
    start powershell -WorkingDirectory $(pwd).Path -ArgumentList "cat $datadir\test5-2.txt | java reversi.client.ReversiClient localhost 50135; pause"
    pause
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}

foreach($tempdir in $dirlist){
	Assign variables to directories
	$srcdir="C:\Users\sli\Documents\Lab7\$tempdir\src"
    echo "---------------------------"
    echo "$tempdir"
    cd $srcdir
    compile
    test1 
    test3
    test4
    test5
}

