param(
    $webAppPath
)

Import-Module $webAppPath\core\URL.psm1 -DisableNameChecking
Import-Module $webAppPath\core\Loaders.psm1 -ArgumentList $webAppPath -DisableNameChecking
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

function Import-Controllers {
	
}

function Route-Request {
param(
    [string] $requestedURL,
    [bool] $isAJAXRequest,
	$Routes #not used yet 19/12/2016
)

    $requestedURL = Trim-FirstAndLastSlashesOnURL -rURL $requestedURL
    
	$controllerFileInfoList = Load-Controllers; #if the file contains "*Controller.ps1" in the controllers directory, it's file information will be returned from ImportControllers()

    foreach ($controllerFile in $controllerFileInfoList) {
        .  $controllerFile.FullName;
    }
	 
	. "$webAppPath\Routes.ps1"

	Import-Module  $webAppPath\core\ViewLoader.psm1 -ArgumentList @($webAppPath,$invokedControllerName,$invokedActionName)
 
	$global:response = ''
	
	$global:found = $false;
	$rLen = $routes.Length;
	for($i=0;$i -lt $rLen;$i++ ) {	
		
		if(($requestedURL -match $routes[$i][0]) -and ($global:found -eq $false) ) {
			[string] $matchedfunctionName = ($requestedURL -split '/')[0];
			[bool] $global:found = $true;
			[string] $missingFunctionError = "Route-Request: Unable to find function: '$matchedfunctionName' in Controller. (Route: "+$Matches[0] + ')';
			
			switch($Matches.Count) {
				1 {  try{$global:response = $routes[$i][1].Invoke($Matches)}catch{$missingFunctionError};break;}
				2 {  try{$global:response = $routes[$i][1].Invoke($Matches[1],$Matches[2])}catch{$missingFunctionError}break;}
				3 {  try{$global:response = $routes[$i][1].Invoke($Matches[1],$Matches[2],$Matches[3])}catch{$missingFunctionError};break}
				4 {  try{$global:response = $routes[$i][1].Invoke($Matches[1],$Matches[2],$Matches[3],$Matches[4])}catch{$missingFunctionError};break}
				default { "Routing: a route couldn't be invoked."}
			}
			
			$global:response
			continue;
			
        }
		
    }
	
}

