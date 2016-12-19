$PowerSurgeMVCPath = 'C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\PowerSurgeMVC\PowerSurgeMVC'

Import-Module $PowerSurgeMVCPath\Core\Routing.psm1 -ArgumentList $PowerSurgeMVCPath -DisableNameChecking;
Import-Module $PowerSurgeMVCPath\Core\Loaders.psm1 -ArgumentList $PowerSurgeMVCPath -DisableNameChecking;

. $PowerSurgeMVCPath\routes.ps1
#Get-Routes

Describe 'Routing' {
	Context 'Exists' {
		<#$routes = @(
					@('^insertcustomheader/([a-z].*)/([a-z].*)', $CustomHeaderController.'Insert-CustomHeader'),
					@('([0-9])/([a-z])$', $DemoController.Index),
					@('Home', $DemoController.Home),
					@('Index/([0-9]{3})/([0-9]{2})', $DemoController.Index),
					@('Shoot/([0-9])/([0-9])',$DemoController.ShootArrow),
					@('Performance/FastRequest',$PerformanceController.FastRequest),
					@('Performance/SlowRequest/([0-9]{2})',$PerformanceController.SlowRequest)
			)
		#>
		It 'Inserts a custom header' {
			Route-Request -requestedURL '/insertcustomheader/steve/rathbone' -isAJAXRequest $false
			
			$controllerFileInfoList = Load-Controllers;
			foreach ($controllerFile in $controllerFileInfoList) {
				.  $controllerFile.FullName;
			}

			
		
			Route-Request -requestedURL '/Performance/FastRequest' -isAJAXRequest $false -Routes $routes
			#$TRUE | Should Be $true 
		}
		It 'Finds FastRequest' { 
			$res =	Route-Request -requestedURL '/Performance/FastRequest' -isAJAXRequest $false 
			$res -match	'FastRequest function called at' | should be $true
		}

		It 'Tries to invoke a controller function that does not exist, but the route match was successful.' { 
			#eg. a matching route was found in the route table, and then jumps into the switch table to run '.Invoke()' with the correct number of parameters, 
			#BUT, because the module does NOT contain the function definition, OR does not export it as a module member, the invokation fails.
			#Error message below:
			<#
			Error: You cannot call a method on a null-valued expression.
 			at Route-Request, C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\PowerSurgeMVC\PowerSurgeMVC\core\Routing.psm1: line 104
				at Start-PowerSurge, C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\PowerSurgeMVC\PowerSurgeMVC\core\powersurgeMVC.ps1: line 47
 				at Init-PowerSurgeEnvironment, C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\PowerSurgeMVC\PowerSurgeMVC\core\init.ps1: line 13

			#>
			$res =	Route-Request -requestedURL '/NoRoute' -isAJAXRequest $false 
			$res -match	'Route-Request: Unable to find function:' | should be $true
		}

		It 'invokes a controller function that accepts 2 apare, but the route match was successful.' { 
			$res = Route-Request -requestedURL '/TestRoute/4/5' -isAJAXRequest $false 
			$res -match	'TestRoute called, param a is: 4, param b is: 5' | should be $true
		}
	}
}
Remove-Module Routing