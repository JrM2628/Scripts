$datadir="C:\Users\sli\Documents\Lab6\.data"
cd "$datadir\..\"
$dirlist=Get-ChildItem -Directory -Name;

Function compile{
	javac .\bee\*.java .\util\*.java .\world\*.java *.java
}

Function test1{
    $beforetime=Get-Date -UFormat %s;
    echo "Test 1"
    echo "Test 1" > $outdir\1-0-0-0.txt
    echo "===================================================================================" >> $outdir\1-0-0-0.txt
    java BeeMain 1 0 0 0 *>> $outdir\1-0-0-0.txt
    "$($(Get-Date -UFormat %s) - $beforetime) seconds" >> "$outdir\1-0-0-0.txt";
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
Function test2{
    echo "Test 2"
    $beforetime=Get-Date -UFormat %s;
    echo "Test 2" >> $outdir\5-0-2-2.txt
    echo "===================================================================================" >> $outdir\5-0-2-2.txt
    java BeeMain 5 0 2 2 *>> $outdir\5-0-2-2.txt
    "$($(Get-Date -UFormat %s) - $beforetime) seconds" >> "$outdir\5-0-2-2.txt";
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
Function test3{
    echo "Test 3"
    $beforetime=Get-Date -UFormat %s;
    echo "Test 3" >> $outdir\10-0-20-20.txt
    echo "===================================================================================">> $outdir\10-0-20-20.txt
    java BeeMain 10 0 20 20 *>> $outdir\10-0-20-20.txt
    "$($(Get-Date -UFormat %s) - $beforetime) seconds" >> "$outdir\10-0-20-20.txt";
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
Function test4{
    echo "Test 4"
    $beforetime=Get-Date -UFormat %s;
    echo "Test 4">> $outdir\5-2-0-0.txt
    echo "===================================================================================" >> $outdir\5-2-0-0.txt
    java BeeMain 5 2 0 0 *>> $outdir\5-2-0-0.txt
    "$($(Get-Date -UFormat %s) - $beforetime) seconds" >> "$outdir\5-2-0-0.txt";
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
Function test5{
    echo "Test 5"
    $beforetime=Get-Date -UFormat %s;
    echo "Test 5" >> $outdir\10-1-1-1.txt
    echo "===================================================================================" >> $outdir\10-1-1-1.txt
    java BeeMain 10 1 1 1 *>> $outdir\10-1-1-1.txt
    "$($(Get-Date -UFormat %s) - $beforetime) seconds" >> "$outdir\10-1-1-1.txt";
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
Function test6{
    echo "Test 6"
    $beforetime=Get-Date -UFormat %s;
    echo "Test 6" >> $outdir\60-10-10-10.txt
    echo "===================================================================================" >> $outdir\60-10-10-10.txt
    java BeeMain 60 10 10 10 *>> $outdir\60-10-10-10.txt
    "$($(Get-Date -UFormat %s) - $beforetime) seconds" >> "$outdir\60-10-10-10.txt";
    echo "$($(Get-Date -UFormat %s) - $beforetime) seconds"
}
foreach($tempdir in $dirlist){
	#Assign variables to directories
	$srcdir="C:\Users\sli\Documents\Lab6\$tempdir\src"
	$outdir = "$srcdir\..\output"
    mkdir "$outdir"	
    echo "---------------------------"
    echo "$tempdir"

    cd $srcdir
    test1 
    test2
    test3
    test4
    test5
    test6
}

