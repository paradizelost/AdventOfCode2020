$inputdata=import-csv -header "Number" .\aocd9input.txt
$inputdata | %{$_.Number = [int64]$_.Number}
$howmanynums=2

foreach($num in ($howmanynums .. $inputdata.count)){


    for($i=0;$i -lt $inputdata.count - $num; $i++){
        $possiblevalues = @()
        $mynums = $inputdata[$i .. ($i + $num -1)]|Select-Object -ExpandProperty Number
        $mysum = $mynums | Measure-Object -sum | Select-Object -ExpandProperty Sum
        if($mysum -eq 15353384){
            $minnum = ($mynums | Measure-Object -minimum).minimum
            $maxnum = ($mynums | Measure-Object -Maximum).Maximum
            write-host "$mynums sum to $mysum"
            write-host "Smallest $minnum + Largest $maxnum = $($minnum + $maxnum)"
            break
        }
        #write-host "$mynums : $mysum"
    }
}