$AngularController = New-Object –TypeName PSObject

$AngularController | Add-Member -MemberType ScriptMethod -Name "Index" -Value {	
	$ViewHashTable = @{
		'firstname' = "Steve";
		'age' = 30;
	}
#Get-View "header"
	#Get-View -ViewData $ViewHashTable;
	#get-view "footer"
}

$AngularController | Add-Member -MemberType ScriptMethod -Name "Create" -Value {	
	#Get-View
}

$AngularController | Add-Member -MemberType ScriptMethod -Name "getfiles" -Value {	
	#Get-View 
	$ViewHashTable = @{
		'message' = "Hello Ian";
		'service' = get-service;
	}

	
	return "you look tired"
	
}