$datadir="C:\Users\sli\Documents\Lab4\.expected"
cd "$datadir\..\"
$dirlist=Get-ChildItem -Directory -Name;


Function Compile(){
	javac .\game\*.java .\heroes\*.java
}

Function RunTests()
{
    cd $srcdir
    java game.HeroStorm 0 0 *> "$outdir\test0-0out.txt"
    java game.HeroStorm 0 1 *> "$outdir\test0-1out.txt"
    java game.HeroStorm 1 1 *> "$outdir\test1-1out.txt"
    java game.HeroStorm 2 2 *> "$outdir\test2-2out.txt"
    java game.HeroStorm 2 3 *> "$outdir\test2-3out.txt"
    java game.HeroStorm 3 3 *> "$outdir\test3-3out.txt"
	java game.HeroStorm 5 5 *> "$outdir\test5-5out.txt"
    java game.HeroStorm 5 7 *> "$outdir\test5-7out.txt"
	java game.HeroStorm 7 7 *> "$outdir\test7-7out.txt"
}


foreach($tempdir in $dirlist){
	#Assign variables to directories
	$srcdir="C:\Users\sli\Documents\Lab4\$tempdir\src"
	$outdir = "$srcdir\..\output"
    mkdir "$outdir"
	
    echo "---------------------------"
    echo "$tempdir" 
    #cat "$outdir\test9out.txt"
    #diff $(cat "$outdir\test0-0out.txt") $(cat "$datadir\0-0.txt")




    cd $srcdir 
    Compile
    RunTests
}

