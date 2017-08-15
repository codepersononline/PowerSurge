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

<#
.SYNOPSIS
Direct the user's web request to the correct controller.

.DESCRIPTION
Route-Request works by doing these things:
1. Trims the URL slashes in case there are double slashes or, no slashes. Examples: http://localhost or http://localhost/ or http://localhost//
2. Load the routing table from routes.ps1.
3. Evaluate $RequestedURL against each regular expression defined in the routing table, starting from the top.
4. Once a route is found, stop looking routes.
5. Load the controller file from disk.
6. Check the returned Controller is type psobject.
7. Check the Controller defines a method/function matching what's in the route table.
8. Invoke the method/function, and pass in the parameters extracted from $RequestedURL.

.PARAMETER RequestedURL
RequestedURL is the entire string after the domain name. eg. http://localhost.com/abc/def/3 equals: /abc/def/3

.PARAMETER IsAJAXRequest
if the Request was sent using ajax, this should be set to true.
paramter is used to determine if templates should be loaded or not.

.PARAMETER Routes
Only used for testing at the moment.

.NOTES
IsAJAXRequest/global templates probably not working.
#>
function Route-Request {
	
param(
	[string] $RequestedURL,
	[bool] $IsAJAXRequest,
	$Routes #not used yet 19/12/2016
)
	New-Variable -Name trimmedURL -Value (Trim-FirstAndLastSlashesOnURL -rURL $RequestedURL) -Option Constant;
	
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
            . $webAppPath\core\viewhelperfunctions.ps1
				
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
Export-ModuleMember -Function 'Route-Request'