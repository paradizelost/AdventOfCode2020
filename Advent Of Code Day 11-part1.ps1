Function Get-StringHash([String] $String,$HashName = "MD5")
{
    $StringBuilder = New-Object System.Text.StringBuilder
    [System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{
    [Void]$StringBuilder.Append($_.ToString("x2"))
}
$StringBuilder.ToString()
}
function Get-OpenSeatCount {
    param (
        [int]$seatrow,
        [int]$seatnum,
        $seatmap
    )
   # write-host "$(Get-StringHash -String ($seatmap -join ''))"
    $positionstocheck=@{
    'UpperLeft'=@(($seatrow -1),($seatnum -1))
    'UpperMiddle'=@(($seatrow -1),($seatnum))
    'UpperRight'=@(($seatrow -1),($seatnum +1))
    'Left'=@(($seatrow),($seatnum -1))
    'Right'=@(($seatrow),($seatnum +1))
    'LowerLeft'=@(($seatrow +1),($seatnum -1))
    'LowerMiddle'=@(($seatrow +1),($seatnum))
    'LowerRight'=@(($seatrow +1),($seatnum +1))
    }
    #write-host $positionstocheck
    #write-host "SEATROW: $seatrow SEATNUM: $seatnum"
    $adjacentseats=""
    foreach($position in $positionstocheck.keys){
        $thisrow, $thisseat = $positionstocheck[$position]
        if($thisrow -eq -1){
            continue
        }
        if($thisrow -gt $seatmap.count -1){
            continue
        }
        if($thisseat -eq -1){
            continue
        }
        if($thisseat -gt $seatmap[$seatrow].length -1){
            continue
        }

        $myposition = $positionstocheck[$position]
        $row = $myposition[0]
        #write-host "$row"
        $seat = $myposition[1]
        #write-host "$seat"
        #write-host $seatmap[$row]
        $myrow = $seatmap[$row].ToCharArray()
        $adjacentseats += $myrow[$seat]
    }
    #write-host $adjacentseats
    return ($adjacentseats.tochararray()|?{$_ -eq '#'}).count
}
function proc-Seats(){
    param(
        $seatmap
    )
    $origmap = $seatmap.clone()

    #$myseatmap= $seatmap.clone()
    #$myseatmap=$seatmap
    for($row=0;$row -lt $seatmap.count; $row++){
        for($seatnum=0; $seatnum -lt ($seatmap[$row].ToCharArray().count); $seatnum++){
            if($seatmap[$row][$seatnum] -ne '.'){
                $occupiedseats = Get-OpenSeatCount -seatrow $row -seatnum $seatnum -seatmap $origmap
                #write-host "Occupied Around $occupiedseats, SEATNUM $seatnum, SEATROW $row"
                if( $occupiedseats -ge 4){
                    #write-host $occupiedseats
                    $myrow = $seatmap[$row].tochararray()
                    $myrow[$seatnum]='L'
                    $seatmap[$row]=$myrow -join ""
                } elseif ($occupiedseats -eq 0) {
                    #write-host $occupiedseats
                    $myrow = $seatmap[$row].tochararray()
                    $myrow[$seatnum]='#'
                    $seatmap[$row]=$myrow -join ""
                }
            }
        }
    }
    $seatmap
}
$seatmap = @(get-content .\aocd11input.txt)
#$seatmap=@('L.LL.LL.LL','LLLLLLL.LL','L.L.L..L..','LLLL.LL.LL','L.LL.LL.LL','L.LLLLL.LL','..L.L.....','LLLLLLLLLL','L.LLLLLL.L','L.LLLLL.LL')
$repeat=$false
$loopnum=0
$optionhashes = @()
do{
    $maphash =Get-StringHash -String ($seatmap -join '')
    $loopnum++
    write-host "Loop $loopnum"
    write-host $maphash
    $seatmap = @(proc-Seats -seatmap $seatmap)
    $seatmap
    if($optionhashes -contains $maphash ){
        write-host "Repeat detected. Stopping"
        $repeat=$true
    } else { 
        $optionhashes += $maphash
    }
    #read-host
} while (
    $repeat -eq $false
)
(($seatmap -join "").tochararray()|?{$_ -eq '#'}).count
