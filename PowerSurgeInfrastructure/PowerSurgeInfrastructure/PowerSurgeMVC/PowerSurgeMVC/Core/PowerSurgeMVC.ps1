<#
	27/09/2014 Steve R.
	Welcome to PowerSurge.
#>

Set-StrictMode -Version Latest;
[psvariable[]] $Global:allvars = $null;

Set-Variable -Name 'PowerSurgeAppPath' `
			 -Value ([string]"$AppDomainPath\PowerSurgeMVC\PowerSurgeMVC") `
			 -Option Constant;

function Start-PowerSurge {
param(
	[System.Web.HttpRequest] $request,
	[System.Web.HttpResponse] $response,
	[string] $AppDomainPath
)   

	Import-Module $PowerSurgeAppPath\config.psm1;
	$global:request = $request;
	$global:response = $response;

	Import-Module $PowerSurgeAppPath\core\Debugging.psm1
	
	Import-Module $PowerSurgeAppPath\core\HttpUtility.psm1;
	Import-Module $PowerSurgeAppPath\core\HttpMethods.psm1;
	#Import-Module $PowerSurgeAppPath\core\RoutingClassic.psm1 -ArgumentList $PowerSurgeAppPath; #routingclassic
	Import-Module $PowerSurgeAppPath\core\Routing.psm1 -ArgumentList $PowerSurgeAppPath;

	Import-Module $PowerSurgeAppPath\App.psm1 -ArgumentList $PowerSurgeAppPath
	

	App\Initialize-App;
	Initialize-Logging;

	Set-Variable -Name 'baseURL' `
		-Value $Request.Url.GetLeftPart([System.UriPartial]::Authority) `
		-Option Constant -Force;

	Debug "Base URL: $baseURL";
	Debug "PowerSurgeAppPath: $PowerSurgeAppPath";
	#$Global:allvars = Get-Variable;
	#Get-CurrentListOfFunctions;
	$ajaxResult = HttpMethods\Request-IsAJAX $request.Headers["X-Requested-With"];
	
	#[string[]]$renderedResponse = Route-Request $request.rawURL $ajaxResult; #routingclassic
	[string[]]$renderedResponse = Route-Request $request.rawURL $ajaxresult #-Routes (Get-Routes)
	
	if($global:AppConfig.debugging -eq $true) {
		return $renderedResponse  + $(Get-DebuggingPage);
	}
	else {
		return $renderedResponse;
	}
	
}

function dumpVariablesToHTMLTable {
	$vars = $Global:allvars;
	$str = $vars.count.ToString();
	
	for($i=0; $i -lt $vars.count;$i++) {
		$str += $vars[$i].Name + $vars[$i].Value +'</br>';
	}
	return $str;
}

function Get-CurrentListOfFunctions {
	Debug ((Get-ChildItem FUNCTION:\) | %{$_.Name.ToString() +'<BR/>'});
}

function Initialize-Logging {
	if($AppConfig.Logging -eq $true) {
		. $PowerSurgeAppPath\core\Logging.ps1;

		# Create the PowerSurgeMVC Logger, using the currently executing file 
		# as the logger's name. 
		$logger = Create-Log4NetLogger $MyInvocation.MyCommand.Name;    
		
		#logging is currently configured to use MSSQL database and not files.
		$logger.Debug([string]::Concat($items['RequestID'], ': Welcome to PowerSurge!'));
		
		$logger.Debug([string]::Concat($items['RequestID'], 
				': PowerSurge core initialised for new web request..'));
	}
}