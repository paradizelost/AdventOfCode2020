function Get-OpenSeatCount {
    param (
        [int]$seatrow,
        [int]$seatnum,
        $seatmap
    )
    $positionstocheck=@{}
    $positionstocheck.add('UpperLeft',@(($seatrow -1),($seatnum -1)))
    $positionstocheck.add('UpperMiddle',@(($seatrow -1),($seatnum)))
    $positionstocheck.add('UpperRight',@(($seatrow -1),($seatnum +1)))
    $positionstocheck.add('Left',@(($seatrow),($seatnum -1)))
    $positionstocheck.add('Right',@(($seatrow),($seatnum +1)))
    $positionstocheck.add('LowerLeft',@(($seatrow +1),($seatnum -1)))
    $positionstocheck.add('LowerMiddle',@(($seatrow +1),($seatnum)))
    $positionstocheck.add('LowerRight',@(($seatrow +1),($seatnum +1)))
    $occupiedSeats=0
    foreach($position in $positionstocheck.keys){
        $row,$num = $positionstocheck.$position
        $myrow = $seatmap[$row]
        try{
            if($myrow[$num] -eq '#'){
                $occupiedSeats++
            }
        } catch{

        }
    }
    return [int]$occupiedSeats
}
function proc-Seats(){
    param(
        $seatmap
    )
    for($row=0;$row -lt $seatmap.count; $row++){
        for($seatnum=0; $seatnum -lt ($seatmap[$row].ToCharArray().count); $seatnum++){
            if($seatmap[$row][$seatnum] -ne '.'){
                $occupiedseats = Get-OpenSeatCount -seatrow $row -seatnum $seatnum -seatmap $seatmap
                #write-host "Occupied Around $occupiedseats, SEATNUM $seatnum, SEATROW $row"
                $myrow = $seatmap[$row].tochararray()
                if( $occupiedseats -ge 4){
                    $myrow[$seatnum]='L'
                    $seatmap[$row]=$myrow -join ""
                } else {
                    $myrow[$seatnum]='#'
                    $seatmap[$row]=$myrow -join ""
                }
            }
        }
    }
    $seatmap
}
$seatmap = @(get-content .\aocd11input.txt)
$nochangesin=0
$loopnum=0
do{
    $loopnum++
    write-host "Loop $loopnum"
    $oldseatmap = @($seatmap)
    $seatmap = proc-Seats -seatmap $seatmap
    if(($oldseatmap -join "") -eq ($seatmap -join "")){
        $nochangesin++
    }
    #$seatmap
} while (
    $nochangesin -lt 3
)
(($seatmap -join "").tochararray()|?{$_ -eq '#'}).count
