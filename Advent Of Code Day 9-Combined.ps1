get-date 
$inputdata=import-csv -header "Number" .\aocd9input.txt
$inputdata | %{$_.Number = [int64]$_.Number}
$buffer=25
$mynumbers=$inputdata[0 .. 24] | select-object -ExpandProperty Number
$tolookfor=-1
for($i=25; $i -lt $inputdata.count; $i++){

    $minval = (($mynumbers|Sort-Object  )[0 .. 1] |measure-object -sum | select-object -ExpandProperty sum)[0]
    $maxval = (($mynumbers|Sort-Object  )[-2 .. -1] |measure-object -sum | select-object -ExpandProperty sum)[0]
    $newnum = $inputdata[$i].Number
    #write-host "Prior $($mynumbers[-1]) : $newnum"
    if($newnum -lt $minval){
        #write-host "ERROR $newnum too low"
        $tolookfor = $newnum
        break
    }
    if($newnum -gt $maxval){
        #write-host "ERROR $newnum too high"
        $tolookfor = $newnum
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
        #write-host "ERROR $newnum not a sum of prior $buffer numbers"
        $tolookfor = $newnum
        break
    }
    $null,$mynumbers=$mynumbers
    $mynumbers += $newnum
}
$howmanynums=2
$found=$false
if($tolookfor -eq -1){
    throw "Invalid Input for final check"
}
write-host "Part 1 Answer is $tolookfor"
foreach($num in ($howmanynums .. $inputdata.count)){
    if($found){break}
    for($i=0;$i -lt $inputdata.count - $num; $i++){
        if($found){
            $break
        }
        $possiblevalues = @()
        $mynums = $inputdata[$i .. ($i + $num -1)]|Select-Object -ExpandProperty Number
        $mysum = $mynums | Measure-Object -sum | Select-Object -ExpandProperty Sum
        if($mysum -eq $tolookfor){
            $minnum = ($mynums | Measure-Object -minimum).minimum
            $maxnum = ($mynums | Measure-Object -Maximum).Maximum
#            write-host "$mynums sum to $mysum"
#            write-host "Smallest $minnum + Largest $maxnum = $($minnum + $maxnum)"
            write-host "Part 2 answer is $($minnum + $maxnum)"
            $found=$true
            break
        }
        #write-host "$mynums : $mysum"
    }
}
get-date