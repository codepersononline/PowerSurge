function Authorized {
param($allowedRoles)
	if($session['loggedin'] -eq $true) {
		if ($allowedRoles -ccontains $session['userRole']){
			return $true
		}
	}
	return $false;

}


