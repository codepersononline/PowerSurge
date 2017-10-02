$Controller = New-Module 'CustomHeaderController' {
param()

	function Insert-CustomHeader {
	param(
		[string] $key,
		[string] $value
	)
		
		$global:Response.AppendHeader($key, $value);
		return "<!DOCTYPE html><html><head></head><body>Custom HTTP Response header set! key: $key, value: $value</body></html>";
	}

	Export-ModuleMember `
		-Function 'Insert-CustomHeader';

} -AsCustomObject;