$inputdata = get-content .\aocd8input.txt
#had to change input line 164 from jmp to nop to have it exit successfully. it was the 5th from last line ran
function run-scenario(){
    param(
        $myinputdata
    )
    $accumulator=0
    $currentline=0
    $ranlines=@{}
    $a=1
    do{
        if($currentline -ge $myinputdata.count){
            write-host "Exiting Gracefully"
            "Exiting Gracefully $accumulator"
            break
        }
        if($ranlines[$currentline]){
            write-host "LOOP: EXITING: $accumulator"
            $a=0
            "ERROR LOOP EXIT $ACCUMULATOR"
            break
        }
        write-host "InputData Index number $currentline, File line number $($currentline+1), instruction: $($myinputdata[$currentline])"
        $ranlines[$currentline]=1
        $command, $linenum = $inputdata[$currentline] -split " "
        if($command -eq 'nop'){
            $currentline += 1
        }elseif($command -eq 'acc'){
            #write-host "Accumulator $linenum"
            if($linenum -like '+*'){
                $accumulator += $linenum -replace "\+"
            } elseif($linenum -like "-*"){
                $accumulator -= $linenum -replace "\-"
            }
            $currentline += 1
        }elseif($command -eq 'jmp'){
        # write-host "Jumping $linenum"
            if($linenum -like '+*'){
                $currentline += $linenum -replace "\+"
            } elseif($linenum -like "-*"){
                $currentline -= $linenum -replace "\-"
            }
        }
    }while($a -eq 1)
}
run-scenario -myinputdata $inputdata 