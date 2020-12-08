$input=get-content "aocd6input.txt" -Raw

$mydata = $input -split "(\r?\n){2}"
$mysum=0
foreach($form in $mydata){
    $group=$form.split("`n")
    $mygroup=@{}
    if($form -eq "`n"){
        continue
    }
    $emptycount = 0
    foreach($person in $group){
        if($person.length -eq 0){
            $emptycount++
            continue
        } else {
            foreach($char in $person.ToCharArray()){
                if(-not($mygroup[$char])){
                    $mygroup[$char]=1    
                } else {
                    $mygroup[$char]= $mygroup[$char]+1
                }
            }
        }
    }

    $mytotal = $mygroup.keys|ForEach-Object {$mygroup[$_]|where-object {[int]$_ -eq ([int]$group.count - [int]$emptycount)}}
    $mysum+=$mytotal.count
    write-host @"
    Count of group: $($group.count)
    Empty Count:    $($emptycount)
    Tallys:         $($mygroup.keys|ForEach-Object {$mygroup[$_]})
    MyTotal:        $mytotal
    MySum:          $mysum
    MyCount:        $($mytotal.count)
    Group Answers:  $group
"@
}
write-host "FINAL: $mysum"