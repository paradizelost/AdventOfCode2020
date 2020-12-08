$inputdata = (get-content -Raw .\aocd7input.txt) -split "`n"
$colorrules=@{}
foreach($rule in $inputdata){
    if($rule -eq ""){
        continue
    } else {
        $rule = $rule -replace "bags", ""
        $rule = $rule -replace "bag", ""
        $outerbag, $innerbags = $rule -split " contain ", 2
        $innerbagsrule= $innerbags-split ","
        $outerbag=$outerbag.trim() -replace '[^a-zA-Z]',""
        $colorrules[$outerbag]=@{}
        foreach($myrule in $innerbagsrule){
            $count, $color = $myrule.trim() -split " ",2
            $color = $color.trim() -replace '[^a-zA-Z]',""
            #write-host "Color:$color-Count:$count"
            $colorrules[$outerbag].add($color,$count)
        }
    }
}
function get-innerbags(){
    param(
        $BagColor
    )
    if($bagcolor -eq "other"){return 1} else {
        $directbags = $colorrules.$BagColor.values |?{$_ -ne "no"}|measure-object -sum|select-object -ExpandProperty Sum
        foreach($bag in $colorrules.$BagColor.keys){
            $numofbag = $colorrules.$BagColor.$bag
            if($numofbag -eq "no"){

            } else {
                for($i=0; $i -lt $numofbag;$i++){
                    get-innerbags -BagColor $bag
                }
                $numofbag
            }

        }
    }
}
get-innerbags -BagColor "shinygold" | measure-object -Sum