$datadir="C:\Users\sli\Documents\Project1\.data"
$dirlist=Get-ChildItem -Directory -Name;

Function WCTests()
{
	#Word_count tests
	python "$srcdir\word_count.py" -h *> "$outdir\test1out.txt"
	python "$srcdir\word_count.py" president "$datadir\q.csv" *> "$outdir\test2out.txt"
	python "$srcdir\word_count.py" query garbage *> "$outdir\test3out.txt"
	python "$srcdir\word_count.py" question "$datadir\q.csv" *> "$outdir\test4out.txt"
}

Function LFTests()
{
	#Letter_Frequency Tests
	python "$srcdir\letter_freq.py" -h *> "$outdir\test5out.txt"
	python "$srcdir\letter_freq.py" -o "$datadir\q.csv" *> "$outdir\test6out.txt"
} 

Function WFTests()
{
	#Word_Frequency Tests
	python "$srcdir\word_freq.py" -h *> "$outdir\test8out.txt"
	python "$srcdir\word_freq.py" -o 3 president "$datadir\q.csv" *> "$outdir\test9out.txt"
	python "$srcdir\word_freq.py" -o 5 query "$datadir\q.csv" *> "$outdir\test10out.txt"
}

Function WLTests
{
	#Word_Length Tests
	python "$srcdir\word_length.py" -h *> "$outdir\test12out.txt"
	python "$srcdir\word_length.py" 2000 1999 "$datadir\q.csv" *> "$outdir\test13out.txt"
	python "$srcdir\word_length.py" -o 1995 2005 "$datadir\q.csv" *> "$outdir\test14out.txt"
}

Function TimeTest()
{
	$beforetime=Get-Date -UFormat %s;
	python "$srcdir\word_length.py" -o 1800 2000 "$datadir\all.csv" *> "$outdir\test0out.txt";
	"$($(Get-Date -UFormat %s) - $beforetime) seconds" >> "$outdir\test0out.txt";
}

Function MPL()
{
	#MATPLOTLIB
	python "$srcdir\letter_freq.py" -p "$datadir\q.csv"
	#MATPLOTLIB
	python "$srcdir\word_freq.py" -p quantity "$datadir\q.csv"
	#MATPLOTLIB
	python "$srcdir\word_length.py" -p 1700 2005 "$datadir\q.csv"
}

foreach($tempdir in $dirlist){
	#Assign variables to directories
	$srcdir="C:\Users\sli\Documents\Project1\$tempdir\src"
	$outdir = "$srcdir\..\out"
    echo $tempdir
	mkdir "$outdir"
	WCTests
    echo "WCTests done"
	LFTests
    echo "LFTests done"
	WFTests
    echo "WFTests done"
	WLTests
    echo "WLTests done"
	TimeTest
    echo "Timetest done"
	MPL
    echo "---------------------------"
    #echo "$tempdir"
    #cat "$outdir\test9out.txt"
    #diff $(cat "$outdir\test9out.txt") $(cat "$datadir\expected\test9out.txt") -Verbose
	pause
}

