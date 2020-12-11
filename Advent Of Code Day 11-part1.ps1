function Get-OpenSeatCount {
    param (
        [int]$seatrow,
        [int]$seatnum,
        $seatmap
    )
    $seatrow.gettype()
    $seatnum.gettype()
    $seatrow = [int]$seatrow
    $seatnum = [int]$seatnum
    $seatrow.gettype()
    $seatnum.gettype()
    write-host "Input: $seatrow , $seatnum"
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
        if($seatmap[$row][$num] -eq '#'){
            $occupiedSeats++
        }
    }
    return $occupiedSeats
}
function proc-Seats(){
    param(
        $seatmap
    )
    for($row=0;$row -lt $seatmap.count; $row++){
        for($seatnum=0, $seatnum -lt $seatmap[$row].ToCharArray().count){
            if((Get-OpenSeatCount -seatrow $row -seatnum $seatnum -seatmap $seatmap) -ge 4){
                $seatmap[$row][$seatnum]='L'
            } else {
                $seatmap[$row][$seatnum]='#'
            }
        }
    }
    $seatmap
}
$seatmap = get-content .\aocd11input.txt
$nochangesin=0
do{
    $oldseatmap = $seatmap
    $seatmap = proc-Seats -seatmap $seatmap
    if($oldseatmap -eq $seatmap){
        $nochangesin++
    }
} while (
    $nochangesin -lt 3
)

