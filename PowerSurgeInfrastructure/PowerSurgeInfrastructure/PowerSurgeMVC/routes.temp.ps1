function Get-Routes {
	$routes = New-Object System.Collections.Generic.List[System.Object[]];
    
	$routes.Add( @('^getcurrentthread$', 'Threading', 'getcurrentthread'))
	$routes.Add( @('^getappdomain$','Threading','GetAppDomain'))
	<#
	$routes.Add( @('^module/AboutMe$',$ModuleController.AboutMe)) 
	$routes.Add( @('^module/AddTwoNumbers/([0-9])/([0-9])$',$ModuleController.AddTwoNumbers)) 
	$routes.Add( @('^module/Download$',$ModuleController.Download)) 
	$routes.Add( @('^module/SimpleForm$',$ModuleController.SimpleForm,'Module'))

	$routes.Add( @('^psobject/AboutMe$',$PSObjectController.AboutMe)) 
	$routes.Add( @('^psobject/AddTwoNumbers/([0-9])/([0-9])$',$PSObjectController.AddTwoNumbers)) 
	$routes.Add( @('^psobject/Download$',$PSObjectController.Download)) 
	
	$routes.Add( @('^insertcustomheader/([a-z].*)/([a-z].*)', $CustomHeaderController.'Insert-CustomHeader')) #see unit tests.
	$routes.Add( @('^Performance/FastRequest',$PerformanceController.FastRequest))	#>
	$routes.Add( @('^Performance/FastRequest','Performance','FastRequest'))
	$routes.Add( @('^Performance/SlowRequest/([0-9]{2})','Performance','SlowRequest'))

	$routes.Add( @('^Samples/Index$','Samples','Index'))
	$routes.Add( @('^Samples/map','Samples','Map'))
	$routes.Add( @('^Samples/GeoJSON','Samples','GeoJSON'))
	
	$routes.Add( @('^processes$','Monitoring','ProcessesXML'))
	$routes.Add( @('^processesjson$','Monitoring','ProcessesJSON'))
	$routes.Add( @('^processeshtml$','Monitoring','ProcessesHTML'))
	$routes.Add( @('^services$','Monitoring','ServicesJSON'))
	
	$routes.Add( @('^Module$','Mock','Index'))
	$routes.Add( @('^Module/ShowAjaxForm$','Module','ShowAJAXForm'))
	$routes.Add( @('^Module/getajaxresponse','Module','Getajaxresponse'))
	$routes.Add( @('^Module/Login$','Module','Login'))
	$routes.Add( @('^Module/LoginProcess$','Module','LoginProcess'))
	$routes.Add( @('^Module/Count$','Module','Count'))
	$routes.Add( @('^Module/Logout$','Module','Logout'))
	
	$routes.Add( @('^Module/Download$','Module', 'Download'))
	$routes.Add( @('^module/SimpleForm$','Module', 'SimpleForm'))
    $routes.Add( @('^module/AboutMe$', 'Module', 'AboutMe')) 
    $routes.Add( @('^module/embeddedstaticfiletest$', 'Module', 'embeddedstaticfiletest')) 
	
	$routes.Add( @('^module/Process$','Module','FireFoxProcess')) 
	
    $routes.Add(@('^date$', 'Date', 'TodaysDate'))

	$routes;
}