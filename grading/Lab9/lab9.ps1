$datadir="C:\Users\sli\Documents\Lab9\.data"
cd "$datadir\..\"
$dirlist=Get-ChildItem -Directory -Name;

Function compile{
	javac *.java
}

Function test1{
    java RITUncompress $datadir\simple8x8.rit *> $outdir\test1out.txt 
}
Function test2{
	java RITUncompress $datadir\ritlogo128x128.rit *> $outdir\test2out.txt    
}
Function test3{
    java RITCompress $datadir\simple8x8.txt $outdir\output3.rit *> $outdir\test3out.txt
}
Function test4{
     java RITCompress $datadir\ritlogo128x128.txt $outdir\output4.rit *> $outdir\test4out.txt   
}

foreach($tempdir in $dirlist){
	$srcdir="C:\Users\sli\Documents\Lab9\$tempdir\src"
	$outdir = "$srcdir\..\output"
    mkdir "$outdir"	
    echo "---------------------------"
    echo "$tempdir"

    cd $srcdir
	compile
    test1 
    test2
	pause
    test3
    test4
}
