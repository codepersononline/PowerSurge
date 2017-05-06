#
# HttpMethods.psm1
#
function Request-HTTPPOST {
	if ($request.HttpMethod -eq 'POST') { return $true; }
	else {return $false; }
}

function Request-HTTPGET {
	if ($request.HttpMethod -eq 'GET') { return $true; }
	else {return $false; }
}

function Request-HTTPPUT {
	if ($request.HttpMethod -eq 'PUT') { return $true; }
	else { return $false; }
}  

function Request-HTTPDELETE { 
    if ($request.HttpMethod -eq "DELETE") { return $true; }
	else { return $false; }
}

function Request-HTTPAJAX ([string]$requestHeader) {
	if ($request.Headers["X-Requested-With"] -eq 'XMLHttpRequest') { return $true }
	else { return $false; }
}