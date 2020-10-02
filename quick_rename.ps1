cd "C:\Users\shell\Downloads\Lab 4 Download Feb 15, 2020 333 PM"

$filelist = Get-Item *
foreach($tempfile in $filelist){
    $newName = $tempfile.Name.Substring(17)
    mv $tempfile $newName
}
