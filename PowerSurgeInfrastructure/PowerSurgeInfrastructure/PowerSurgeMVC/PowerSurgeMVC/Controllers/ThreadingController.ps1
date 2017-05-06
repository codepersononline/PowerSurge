$Controller = New-Module {
	function GetCurrentThread() {
		 

		([System.Threading.Thread]::CurrentThread |Out-String) -replace "`n", '<br />'
		$response.gethashcode()
	}

	function GetAppDomain() {
		 [System.AppDomain]::CurrentDomain.FriendlyName
	}

} -AsCustomObject