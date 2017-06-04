param(
    $script:webAppPath
)

function Get-ControllerFilePath {
param(
    [string] $webAppPath = $script:webAppPath,
	[string] $Name 
)
	if([string]::IsNullOrEmpty($Name)){
		throw 'Controller name is null or empty, cannot load file.'
	}
	
	$fPath = "$webAppPath\Controllers\$Name" + 'Controller.ps1';
	
	if([System.IO.File]::Exists($fPath)) {
		return $fPath
	}
	else {
		throw "Controller at $fPath does not exist."
	}
}    