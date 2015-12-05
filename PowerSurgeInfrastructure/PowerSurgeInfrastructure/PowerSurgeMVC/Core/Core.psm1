
#. $PSScriptRoot\config.ps1
#. $PSScriptRoot\securityutilityfunctions.ps1
#. $PSScriptRoot\DB.ps1
#. $PSScriptRoot\ViewHelperFunctions.ps1

function New-Request{ 
param(
[string]$URL
)
	#return "hello new request"
	Route-Request $URL
}

#Export-ModuleMember -function "New-Request"
