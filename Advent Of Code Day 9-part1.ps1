$inputdata=import-csv -header "Number" .\aocd9input.txt
$inputdata | %{$_.Number = [int64]$_.Number}
$buffer=25
$mynumbers=$inputdata[0 .. 24] | select-object -ExpandProperty Number
for($i=25; $i -lt $inputdata.count; $i++){

    $minval = (($mynumbers|Sort-Object  )[0 .. 1] |measure-object -sum | select-object -ExpandProperty sum)[0]
    $maxval = (($mynumbers|Sort-Object  )[-2 .. -1] |measure-object -sum | select-object -ExpandProperty sum)[0]
    $newnum = $inputdata[$i].Number
    write-host "Prior $($mynumbers[-1]) : $newnum"
    if($newnum -lt $minval){
        write-host "ERROR $newnum too low"
        break
    }
    if($newnum -gt $maxval){
        write-host "ERROR $newnum too high"
        break
    }
    $possiblevalues = @()
    for($b=0;$b -lt $mynumbers.Count;$b++){
        $mynum=$mynumbers[$b]
        for($a=1;$a -lt $mynumbers.count;$a++ ){
            $nextnum = $mynumbers[$a]
            if($mynum -eq $nextnum){
                #write-host "$mynum is same as $nextnum"
                continue
            }
            $possiblevalues += $mynum + $nextnum
        }
    }
    if($possiblevalues -notcontains $newnum){
        write-host "ERROR $newnum not a sum of prior $buffer numbers"
        break
    }
    $null,$mynumbers=$mynumbers
    $mynumbers += $newnum
}
get-date