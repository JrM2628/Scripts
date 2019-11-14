$datadir="C:\Users\sli\Documents\Lab5\.data"
cd "$datadir\..\"
$dirlist=Get-ChildItem -Directory -Name;


Function test1{
    echo "Test 1" > $outdir\output.txt
    echo "===================================================================================" >> $outdir\output.txt
    java SIS $datadir\course-1.txt $datadir\professor-1.txt $datadir\student-1.txt $datadir\input-1.txt *>> $outdir\output.txt
}
Function test2{
    echo "Test 2" >> $outdir\output.txt
    echo "===================================================================================" >> $outdir\output.txt
    java SIS $datadir\course-1.txt $datadir\professor-1.txt $datadir\student-1.txt $datadir\input-2.txt *>> $outdir\output.txt 
}
Function test3{
    echo "Test 3" >> $outdir\output.txt
    echo "===================================================================================">> $outdir\output.txt
    java SIS $datadir\course-1.txt $datadir\professor-1.txt $datadir\student-1.txt $datadir\input-3.txt *>> $outdir\output.txt
}
Function test4{
    echo "Test 4">> $outdir\output.txt
    echo "===================================================================================" >> $outdir\output.txt
    java SIS $datadir\course-1.txt $datadir\professor-1.txt $datadir\student-1.txt $datadir\input-4.txt *>> $outdir\output.txt
}
Function test5{
    echo "Test 5" >> $outdir\output.txt
    echo "===================================================================================" >> $outdir\output.txt
    java SIS $datadir\course-1.txt $datadir\professor-1.txt $datadir\student-1.txt $datadir\input-5.txt *>> $outdir\output.txt
}

foreach($tempdir in $dirlist){
	#Assign variables to directories
	$srcdir="C:\Users\sli\Documents\Lab5\$tempdir\src"
	$outdir = "$srcdir\..\output"
    mkdir "$outdir"	
    echo "---------------------------"
    echo "$tempdir"

    cd $srcdir
    javac *.java
    test1 
    test2
    test3
    test4
    test5
}

