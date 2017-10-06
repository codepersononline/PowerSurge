Import-Module .\PowerSurgeMVC\Core\Routing.psm1 -ArgumentList "$PWD\PowerSurgeMVC" -DisableNameChecking;

Describe 'Routing' {
	Context 'When requesting a webpage with a request string' {
		
		Copy-Item .\PowerSurgeMVC\PesterResources\PerformanceController.ps1 -Destination .\PowerSurgeMVC\Controllers
		
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
			$res = Route-Request -requestedURL '/NoRoute' -isAJAXRequest $false 
			$res -match	'Route-Request: Unable to find function:' | should be $true
		}

		It "Invokes a controller's function that accepts 2 params, and the route match is successful." { 
			$res = Route-Request -requestedURL '/TestRoute/4/5' -isAJAXRequest $false 
			$res -match	'TestRoute called, param a is: 4, param b is: 5' | should be $true
		}
	}
	Remove-Item .\PowerSurgeMVC\Controllers\PerformanceController.ps1
}
Remove-Module Routing