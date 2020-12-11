function Get-OpenSeatCount {
    param (
        [int]$seatrow,
        [int]$seatnum
    )
    $seatrow.gettype()
    $seatnum.gettype()
    $seatrow = [int]$seatrow
    $seatnum = [int]$seatnum
    $seatrow.gettype()
    $seatnum.gettype()
    write-host "Input: $seatrow , $seatnum"
    $positionstocheck=@{}
    $positionstocheck.add('UpperLeft',@($seatrow -1,$seatnum -1))
    $positionstocheck.add('UpperMiddle',@($seatrow -1,$seatnum))
    $positionstocheck.add('UpperRight',@($seatrow -1,$seatnum +1))
    $positionstocheck.add('Left',@($seatrow,$seatnum -1))
    $positionstocheck.add('Right',@($seatrow,$seatnum +1))
    $positionstocheck.add('LowerLeft',@($seatrow +1,$seatnum -1))
    $positionstocheck.add('LowerMiddle',@($seatrow +1,$seatnum))
    $positionstocheck.add('LowerRight',@($seatrow +1,$seatnum +1))
    $occupiedSeats=0
    foreach($position in $positionstocheck.keys){
        $row,$num = $positionstocheck.$position
        if($seatmap[$row][$num] -eq '#'){
            $occupiedSeats++
        }
    }
    return $occupiedSeats
}
$seatmap = get-content .\aocd11input.txt
Get-OpenSeatCount -seatrow 33 -seatnum 5