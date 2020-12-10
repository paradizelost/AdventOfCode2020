$myinput = get-content .\aocd10input.txt
$myinput = $myinput | %{[int]$_} | Sort-Object
$adapterjoltage = 0
$differences=@{}
$differences[3]=1
$endjolts=$myinput[-1]+3
#write-host $endjolts
for($i=0; $i -lt $myinput.count ; $i++){
    $difference = $myinput[$i] - $adapterjoltage
    write-host "Diff: $difference"
    if($differences[$difference]){
        $differences[$difference]++
    } else {
        $differences[$difference]=1
    }
    $adapterjoltage = $myinput[$i]
}
$differences[3] * $differences[1]