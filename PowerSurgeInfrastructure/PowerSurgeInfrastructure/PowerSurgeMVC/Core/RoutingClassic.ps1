$invokedControllerName = "";
$invokedActionName = "";


. $LeslieAppBasePath\core\URL.ps1
. $LeslieAppBasePath\core\Loaders.ps1


function Route-Request {
param(
    [string]$IncomingURL
)
    
    if ($IncomingURL -ne '/'){
        [object[]]$IncomingURLParts =  TrimFirstAndLastSlashesOnURL $IncomingURL;
    
        if($IncomingURLParts.count -ge 1) {
            
            #uncomment the three lines below to make the global template work.
            if($appConfig.useGlobalView) {
                
                $returnedView = $ControllerDispatcher.Invoke($IncomingURLParts) #invoking the controller will inevitably return a view..
        
                $GloablViewHashTable = @{'ControllerResult' = $returnedView} #set the view content to an item in a hash table...
                
                Get-View "global" -ViewData $GloablViewHashTable #inject the view returned by the controller into the global view...
            }
            else {
                $ControllerDispatcher.Invoke($IncomingURLParts)#i.e we want to manage all the html from the controllers!
            }

        }
    }
    else {
         return $HomeController.Index()
    }
}

 $controllerFileInfoList = Load-Controllers #if the file contains "*Controller.ps1" in the controllers directory, it's file information will be returned from ImportControllers()
 foreach ($controllerFile in $controllerFileInfoList) {
     .  $controllerFile.FullName                                #figure out the name of each controller file, and then invoke it so we can see the variables in the file...

     $ControllerBaseFileName = $controllerFile.BaseName         #possibly uneccesary, only left for clarity. (gets the string name of the filename that contains the controller variables that we need...) controller filenames and variable names match remember ;) 
     $URLFriendlyControllerName = $ControllerBaseFileName.Remove($ControllerBaseFileName.Length - 10) #strip off the "Controller" part of the string...
     $ControllerCollection.Add($URLFriendlyControllerName,(Get-Variable $controllerFile.BaseName).Value) #.. and add it into our controller lookup table...
}

$ControllerDispatcher = New-Object -TypeName PSObject
$ControllerDispatcher | Add-Member -MemberType ScriptMethod -Name "Invoke" -Value { 
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


