param(
    $webAppPath
)

$invokedControllerName = '';
$invokedActionName = '';

Import-Module $webAppPath\core\URL.psm1
Import-Module $webAppPath\core\Loaders.psm1 -ArgumentList $webAppPath
Import-Module $webAppPath\core\securityutilityfunctions.psm1;
. $webAppPath\core\viewhelperfunctions.ps1;

function Route-Request {
param(
    [string]$requestedURL,
    [bool]$isAJAXRequest
)
    Debug 'Route-Request called'

    [string[]]$SplitURLParts = $null;
    [string]$renderedControllerandViews = '';
    [hashtable]$GlobalViewData = $null;
    [string]$cleanedURL = $null;
    $ControllerCollection = @{};

    if ($isAJAXRequest) { 
        $appConfig.useGlobalView = $false; 
    }

    if ($requestedURL -eq '/' ){
         $requestedURL = $AppConfig.defaultRoute;
    }
  
    Debug 'hello debugging'

    $ControllerCollection = Build-ControllerLookupTable;
    
    
    $requestedURLTrimmed = Trim-FirstAndLastSlashesOnURL $requestedURL;
    $SplitURLParts = $requestedURLTrimmed.Split('/');
    
    if($SplitURLParts.count -ge 1) {
        
        if($appConfig.useGlobalView) {

            $returnedView = Invoke-Controller $SplitURLParts $ControllerCollection #invoking the controller will inevitably return a view (or just html from the controller..)
            $GlobalViewData = @{'ControllerResult' = $returnedView} #set the view content to an item in a hash table...
            $renderedControllerandViews = Get-View -ViewName 'global' -ViewData $GlobalViewData #inject the view returned by the controller into the global view...
        }
        else {
            $renderedControllerandViews = Invoke-Controller $SplitURLParts $ControllerCollection #i.e we want to manage all the html from the controllers!
        }
            return $renderedControllerandViews;
    }
}
function Build-ControllerLookupTable {
    $Controllers = @{}; 
    
    $controllerFileInfoList = Load-Controllers; #if the file contains "*Controller.ps1" in the controllers directory, it's file information will be returned from ImportControllers()

    foreach ($controllerFile in $controllerFileInfoList) {
        .  $controllerFile.FullName;                             #figure out the name of each controller file, and then invoke it so we can see the variables in the file...

        $ControllerBaseFileName = $controllerFile.BaseName ;        #possibly uneccesary, only left for clarity. (gets the string name of the filename that contains the controller variables that we need...) controller filenames and variable names match remember ;) 
        $URLFriendlyControllerName = $ControllerBaseFileName.Remove($ControllerBaseFileName.Length - 10) #strip off the "Controller" part of the string...
        $Controllers.Add($URLFriendlyControllerName,(Get-Variable $controllerFile.BaseName).Value) #.. and add it into our controller lookup table...
    }

    return $Controllers;
}      

function Invoke-Controller {
    param (
        $explodedURLArray,
        $ControllerCollection
    )

    $arrayLength = $explodedURLArray.Count

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
    Debug "hello $invokedActionName"
    Import-Module  $webAppPath\core\ViewLoader.psm1 -ArgumentList @($webAppPath,$invokedControllerName,$invokedActionName)

    #now we invoke the controller and the action.
    switch ($arrayLength) {
        1 { $ControllerCollection.$var0."Index".Invoke(); break;} #needs more work (functionality controls the invoking of 'index' methods when the method/action isn't specified...)
        2 { $ControllerCollection.$var0.$var1.Invoke(); break;}
        3 { $ControllerCollection.$var0.$var1.Invoke($var2); break; }
        4 { $ControllerCollection.$var0.$var1.Invoke($var2,$var3); break; }
        5 { $ControllerCollection.$var0.$var1.Invoke($var2,$var3,$var4); break; }
        default { "Error: could not match method"; break;}
    }
}
