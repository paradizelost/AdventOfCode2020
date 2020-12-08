$input=get-content "aocd6input.txt" -Raw

$mydata = $input -split "(\r?\n){2}"
$mysum=0
foreach($form in $mydata){
    $mygroup=@{}
    if($form -eq "`n"){
        continue
    }
    foreach($person in ($form -split "(\r?\n)")){
        if($person -eq "`n"){
            continue
        } else {
            foreach($char in $person.ToCharArray()){
                $mygroup[$char]=1
            }
        }
    }
    $mytotal = $mygroup.keys|%{$mygroup[$_]} | measure-object -Sum|Select-Object -ExpandProperty SUm
    write-host $mytotal
    $mysum+=[int]$mytotal
}
write-host "FINAL: $mysum"