function Get-Routes {
	[CmdletBinding()]
	[OutputType([System.Collections.Generic.List[System.string[]]])]
	$routes = New-Object System.Collections.Generic.List[System.string[]];
	
	$routes.Add( @('^$', 'Home', 'Index'));
	$routes.Add( @('^About$', 'Home', 'About'));
	
	## Define new routes here ##
	
	$routes; 
}