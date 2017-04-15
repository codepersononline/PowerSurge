function Get-Routes {
	$routes = New-Object System.Collections.Generic.List[System.Object[]];

	$routes.Add( @('^module/AboutMe$',$ModuleController.AboutMe)) 
	$routes.Add( @('^module/AddTwoNumbers/([0-9])/([0-9])$',$ModuleController.AddTwoNumbers)) 
	$routes.Add( @('^module/Download$',$ModuleController.Download)) 
	$routes.Add( @('^module/SimpleForm$',$ModuleController.SimpleForm,'Module'))

	$routes.Add( @('^psobject/AboutMe$',$PSObjectController.AboutMe)) 
	$routes.Add( @('^psobject/AddTwoNumbers/([0-9])/([0-9])$',$PSObjectController.AddTwoNumbers)) 
	$routes.Add( @('^psobject/Download$',$PSObjectController.Download)) 
	
	$routes.Add( @('^insertcustomheader/([a-z].*)/([a-z].*)', $CustomHeaderController.'Insert-CustomHeader')) #see unit tests.
	$routes.Add( @('^Performance/FastRequest',$PerformanceController.FastRequest))
	$routes.Add( @('^Performance/FastRequest',$PerformanceController.FastRequest))
	$routes.Add( @('^Performance/SlowRequest/([0-9]{2})',$PerformanceController.SlowRequest))
	
	$routes.Add( @('^Samples/Index$',$SamplesController.Index))
	$routes.Add( @('^Samples/map',$SamplesController.Map))
	$routes.Add( @('^Samples/GeoJSON',$SamplesController.GeoJSON))
	
	$routes.Add( @('^processes$',$MonitoringController.ProcessesXML))
	$routes.Add( @('^processesjson$',$MonitoringController.ProcessesJSON))
	$routes.Add( @('^services$',$MonitoringController.ServicesJSON))
	
	
	
	$routes.Add( @('^Mock$',$MockController.Index))
	$routes.Add( @('^Mock/Download$',$MockController.Download))
	$routes.Add( @('^Mock/SimpleForm$',$MockController.SimpleForm,'Mock'))

	$routes
}