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
$options =0
function get-outerbagoptions(){
    param (
        $BagColor
    )
    foreach($myrule in $colorrules.keys){
        if($colorrules[$myrule]."$bagcolor"){
            get-outerbagoptions -BagColor $myrule
            $myrule
        }
    }
}
get-outerbagoptions -bagcolor "shinygold"|select-object -Unique|Measure-Object
