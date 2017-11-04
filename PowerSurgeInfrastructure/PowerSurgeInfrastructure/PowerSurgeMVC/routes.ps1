function Get-Routes {
	[CmdletBinding()]
	[OutputType([System.Collections.Generic.List[System.string[]]])]
	$routes = New-Object System.Collections.Generic.List[System.string[]];
	$null = $routes.Add( 
		@('^$', 'Home', 'Index'));
	$null = $routes.Add( @('^About$', 'Home', 'About'));
	
	$routes
}