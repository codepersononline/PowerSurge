param(
    $webAppPath
)

Import-Module $webAppPath\core\URL.psm1
Import-Module $webAppPath\core\Loaders.psm1 -ArgumentList $webAppPath
#Import-Module $webAppPath\core\securityutilityfunctions.psm1;
#Import-Module $webAppPath\core\HttpUtility.psm1;

. $webAppPath\core\viewhelperfunctions.ps1;

function Is-Controller {
param(
    $controller
)
    if($controller -is [PSCustomObject] ) {
		return "valid"
    } else {
		return "invalid"
    }

}

function Check-ControllerHasScriptMethodDefinition {
param(
    [Parameter(Mandatory=$true)]
    [PSCustomObject]$Controller,
    [Parameter(Mandatory=$true)]    
    [string] $ScriptMethod,
    [Parameter(Mandatory=$true)]
    [string] $controllerPath
)
    $methodMatches = 0;

    $methodMatches = $Controller| 
                        Get-Member | 
                        Where-Object -Property Name -Match $ScriptMethod |
                    Where-Object -Property MemberType -Match 'ScriptMethod';

    if($methodMatches.Count -eq 1) {return $true}
    if($methodMatches.Count -eq 0) {throw "Controller: $ControllerPath does not contain a definition for scriptmethod: $ScriptMethod"}
    else {throw "Controller: $ControllerPath. has more than one definition for scriptmethod: $ScriptMethod"}
}

function Route-Request {
param(
    [string] $requestedURL,
    [bool] $isAJAXRequest
)

    $requestedURL = $requestedURL.Remove(0,1);
    $controllerFileInfoList = Load-Controllers; #if the file contains "*Controller.ps1" in the controllers directory, it's file information will be returned from ImportControllers()

    foreach ($controllerFile in $controllerFileInfoList) {
        .  $controllerFile.FullName;
    }
    
	. "$webAppPath\Routes.ps1"

	    Import-Module  $webAppPath\core\ViewLoader.psm1 -ArgumentList @($webAppPath,$invokedControllerName,$invokedActionName)
    
	Get-Routes | % {
        if($requestedURL -match $_[0]) {
            $currentRoute = $_;

            switch($Matches.Count) {
               1 {  $currentRoute[1].Invoke($Matches)}
               2 {  $currentRoute[1].Invoke($Matches[1],$Matches[2])}
               3 {  $currentRoute[1].Invoke($Matches[1],$Matches[2],$Matches[3])}
               4 {  $currentRoute[1].Invoke($Matches[1],$Matches[2],$Matches[3],$Matches[4])}
                default {throw "Routing: a route couldn't be invoked."}
            }
        }
        
    }
}

