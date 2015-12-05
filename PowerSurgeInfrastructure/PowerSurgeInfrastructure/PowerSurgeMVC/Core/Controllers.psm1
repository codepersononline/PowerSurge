function steve {
return "rathbone"
}

function Invoke-Controller {
param ($explodedURLArray)

     [int]$arrayLength = $explodedURLArray.Count

    for ($i = 0; $i -lt $arrayLength;++$i){
        New-Variable -Name "var$i" -Value $explodedURLArray[$i]
    }
    #these two if statements help with locating the view when no action has been set in the URL.
    if($arrayLength -eq 1) {
        $invokedControllerName = $var0;
        $invokedActionName = "Index";
    }
    elseif($arrayLength -ge 2) {
        $invokedControllerName = $var0;
        $invokedActionName = $var1;
    }
    #now we invoke the controller and the action.
    switch ($arrayLength) {
        1 { $ControllerCollection.$var0."Index".Invoke(); break;} #needs more work (functionality controls the invoking of 'index' methods when action isn't specified...)
        2 { $ControllerCollection.$var0.$var1.Invoke(); break;}
        3 { $ControllerCollection.$var0.$var1.Invoke($var2); break; }
        4 { $ControllerCollection.$var0.$var1.Invoke($var2,$var3); break; }
        5 { $ControllerCollection.$var0.$var1.Invoke($var2,$var3,$var4); break; }
        default { "Error: could not match method"; break;}
    }
}

