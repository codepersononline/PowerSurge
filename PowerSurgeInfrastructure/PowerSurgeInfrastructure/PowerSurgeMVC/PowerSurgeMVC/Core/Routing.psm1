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

function Route-Request {
param(
	[string] $requestedURL,
	[bool] $isAJAXRequest,
	$Routes #not used yet 19/12/2016
)
	
	$requestedURL = Trim-FirstAndLastSlashesOnURL -rURL $requestedURL
	$controllerFileInfoList = Load-Controllers; #if the file contains "*Controller.ps1" in the controllers directory, it's file information will be returned from ImportControllers()
	foreach ($controllerFile in $controllerFileInfoList) {
		. $controllerFile.FullName;
    }

	. "$webAppPath\Routes.ps1";
	$responseBody = ''; #why was this GLOBAL, is it required for the views??
	$yourRoutes = Get-Routes
	$global:found = $false;
	$routeCount = $yourRoutes.Count;

	if($routeCount -gt 0){
		for($i=0;$i -lt $routeCount; $i++) {	
			
			if(($global:found -eq $false) -and ($requestedURL -match $yourRoutes[$i][0])) {
				[string] $matchedfunctionName = $yourRoutes[$i][1].name
				[string] $invokedControllerName = $yourRoutes[$i][2]
				Import-Module  $webAppPath\core\ViewLoader.psm1 -ArgumentList @($webAppPath,$invokedControllerName,$matchedfunctionName)
			
				[bool] $global:found = $true;
				[string] $missingFunctionError = "Route-Request: Unable to find function: '$matchedfunctionName' in Controller. (Route: "+$Matches[0] + ')';
			
				switch($Matches.Count) {
					1 {  try{$responseBody = $yourRoutes[$i][1].Invoke($Matches)}catch{$missingFunctionError};break;}
					2 {  try{$responseBody = $yourRoutes[$i][1].Invoke($Matches[1],$Matches[2])}catch{$missingFunctionError}break;}
					3 {  try{$responseBody = $yourRoutes[$i][1].Invoke($Matches[1],$Matches[2],$Matches[3])}catch{$missingFunctionError};break}
					4 {  try{$responseBody = $yourRoutes[$i][1].Invoke($Matches[1],$Matches[2],$Matches[3],$Matches[4])}catch{$missingFunctionError};break}
					default { "Routing: a route couldn't be invoked."}
				} #end switch
			
				$responseBody
				continue;
			
			}#end if
		} #end for
	}#end if
	else {
		throw '0 routes were found in your route table. Please check your routes.ps1 file, and add 1 or more routes'
	}
}