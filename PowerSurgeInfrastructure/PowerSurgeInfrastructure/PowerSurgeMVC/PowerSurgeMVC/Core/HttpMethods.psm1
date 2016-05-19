#
# HttpMethods.psm1
#
function Is-HttpPOST {
	if ($request.HttpMethod -eq 'POST') { return $true; }
	else {return $false; }
}

function Is-HttpGET {
	if ($request.HttpMethod -eq 'GET') { return $true; }
	else {return $false; }
}

function Is-HttpPUT {
	if ($request.HttpMethod -eq 'PUT') { return $true; }
	else { return $false; }
}  

function Is-HttpDELETE { 
    if ($request.HttpMethod -eq "DELETE") { return $true; }
	else { return $false; }
}

function Request-IsAJAX ([string]$requestHeader) {
	if ($requestHeader -eq 'XMLHttpRequest') { return $true }
	else { return $false; }
}