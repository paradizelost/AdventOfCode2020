$cookievalue = get-content .\Cookie.txt
$cookie = New-Object system.net.cookie
$cookie.name="session"
$cookie.domain = "adventofcode.com"
$cookie.Value=$cookievalue
$websession = new-object Microsoft.PowerShell.Commands.WebRequestSession
$websession.cookies.add($cookie)
$inputdata = (Invoke-RestMethod -Uri https://adventofcode.com/2020/day/12/input -Method GET -WebSession $websession) -split "\r?\n"

$position = @{
    XAxis=0;
    YAxis=0;
    Facing=@{
        0="E";
        1="N";
        2="W";
        3="S";
    };
    FTurn=0;
}
$outerbounds = @{
    MaxXAxis=0;
    MinXAxis=0;
    MaxYAxis=0;
    MinYAxis=0;
}
function Update-Facing (){
    param(
        $numberOfTurns
    )
    #write-host $numberOfTurns
    if($numberOfTurns -lt 0){
        $tempnum = 4 + $numberOfTurns
        $numberofturns = [math]::abs($tempnum)
    }
    $currentfacing = $position.fturn
    $position.fturn = ($currentfacing + $numberOfTurns) % 4
}
function Update-MaxDistance(){
    #$position
    if($position.XAxis -gt $outerbounds.MaxXAxis){
        $outerbounds.MaxXAxis=$position.XAxis
    }
    if($position.YAxis -gt $outerbounds.MaxYAxis){
        $outerbounds.MaxYAxis=$position.YAxis
    }
    if($position.XAxis -lt $outerbounds.MinXAxis){
        $outerbounds.MinXAxis=$position.XAxis
    }
    if($position.YAxis -lt $outerbounds.MinYAxis){
        $outerbounds.MinYAxis=$position.YAxis
    }
}
function Move-Direction(){
    param(
        $axis,
        $distance
    )
    if($axis -eq "XAxis"){
        $position.XAxis += $distance
    }
    if($axis -eq "YAxis"){
        $position.YAxis += $distance
    }
}
foreach($line in $inputdata){
    if($line -eq ''){continue}
    $direction = $line.ToCharArray()[0]
    [int]$distance = $line.ToCharArray()[1..$line.Length] -join ""
    switch ($direction){
        "N"{
            Move-Direction -axis "YAxis" -distance $distance
        };
        "S"{

            Move-Direction -axis "YAxis" -distance (-$distance)
            
        };
        "E"{
            Move-Direction -axis "XAxis" -distance $distance
        };
        "W"{
            Move-Direction -axis "XAxis" -distance (-$distance)
        };
        "L"{
            update-facing -numberOfTurns ($distance/90)
        };
        "R"{
            update-facing -numberOfTurns (-$distance/90)
        };
        "F"{
            if($position.facing[$position.fturn] -eq "N"){
                Move-Direction -axis "YAxis" -distance $distance
            } elseif($position.facing[$position.fturn] -eq "S"){
                Move-Direction -axis "YAxis" -distance (-$distance)
            } elseif($position.facing[$position.fturn] -eq "E"){
                Move-Direction -axis "XAxis" -distance $distance
            } elseif($position.facing[$position.fturn] -eq "W"){
                Move-Direction -axis "XAxis" -distance (-$distance)
            }
        };
    }
    Update-MaxDistance   
}
[math]::abs($position.XAxis) + [MATH]::abs($position.YAxis)