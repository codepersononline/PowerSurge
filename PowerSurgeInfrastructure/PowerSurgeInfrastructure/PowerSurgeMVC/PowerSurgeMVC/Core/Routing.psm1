param(
	$webAppPath
)

Import-Module $webAppPath\core\URL.psm1 -DisableNameChecking
Import-Module $webAppPath\core\ControllerLoader.psm1 -ArgumentList $webAppPath -DisableNameChecking
#Import-Module $webAppPath\core\securityutilityfunctions.psm1;
#Import-Module $webAppPath\core\HttpUtility.psm1;

. $webAppPath\core\viewhelperfunctions.ps1;

function Check-ControllerHasScriptMethodDefinition {
param(
	[Parameter(Mandatory=$true)]    
	[string] $ScriptMethod,
	[Parameter(Mandatory=$true)]
	[string] $ControllerName
)
	New-Variable -Name methodMatches -Option Constant -Value (
		Get-Member -InputObject $Controller | 
			Where-Object -Property Name -eq $ScriptMethod |
			Where-Object -Property MemberType -Match 'ScriptMethod'
	)

	if($methodMatches.Count -eq 1) {return $true}
	if($methodMatches.Count -eq 0) {throw "'$ControllerName' controller does not contain a function definition for '$ScriptMethod'"}
	else {throw "'$ControllerName' controller has more than one definition for scriptmethod '$ScriptMethod'"}
}

function Route-Request {
param(
	[string] $requestedURL,
	[bool] $isAJAXRequest,
	$Routes #not used yet 19/12/2016
)
	New-Variable -Name trimmedURL -Value (Trim-FirstAndLastSlashesOnURL -rURL $requestedURL) -Option Constant;
	
	. "$webAppPath\Routes.ps1";
	New-Variable -Name yourRoutes -Value (Get-Routes) -Option Constant;
	New-Variable -Name routeCount -Value ($yourRoutes.Count) -Option Constant;
	
	if($routeCount -eq 0) {throw 'No routes found in route table!';}

	$responseBody = ''; #why was this GLOBAL, is it required for the views??
	$global:found = $false;

	for($i=0;$i -lt $routeCount; $i++) {	
			
		if(($global:found -eq $false) -and ($trimmedURL -match $yourRoutes[$i][0])) {
			[bool] $global:found = $true;
			New-Variable -Name ControllerName -Value ($yourRoutes[$i][1]) -Option Constant
			New-Variable -Name FunctionName -Value ($yourRoutes[$i][2]) -Option Constant
			New-Variable -Name ControllerFilePath -Value (Get-ControllerFilePath -Name $ControllerName) -Option Constant
			
			. $ControllerFilePath #$Controller (module as custom object) is implicitly loaded into parent scope.

			# exit early because the controller is not a custom object
			if($Controller -isnot [PSCustomObject]) {throw 'Controller is not of type PSCustomObject'}
			
			# exit early because the controller does not define a function / scriptmethod that was loaded from the route table.
			if((Check-ControllerHasScriptMethodDefinition -ControllerName $ControllerName -ScriptMethod $FunctionName) -eq $false) {return} 
				
			Import-Module $webAppPath\core\ViewLoader.psm1 -ArgumentList @($webAppPath,$ControllerName,$FunctionName) -DisableNameChecking
				
			switch($Matches.Count) {
				1 { 
					$responseBody = $Controller.$FunctionName.Invoke($Matches);
					break;
				}
				2 {
					$responseBody = $Controller.$FunctionName.Invoke($Matches[1],$Matches[2]);
					break;
				}
				3 {
					$responseBody = $Controller.$FunctionName.Invoke($Matches[1],$Matches[2],$Matches[3]);
					break;
				}
				4 {
					$responseBody = $Controller.$FunctionName.Invoke($Matches[1],$Matches[2],$Matches[3],$Matches[4]);
					break;
				}
				default { throw "Routing: a route couldn't be invoked.";}
			} #end switch
			
			$responseBody;
			continue;
			
		}#end if
	} #end for

	if($global:found -eq $false) {$response.StatusCode = 404}
}