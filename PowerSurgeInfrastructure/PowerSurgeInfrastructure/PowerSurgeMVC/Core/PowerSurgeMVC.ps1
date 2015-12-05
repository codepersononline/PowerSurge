<#
27/09/2014 Steve R.
Welcome to PowerSurgeMVC.
#>

set-strictmode -version 2.0
$LeslieAppBasePath = [string]::Concat($AppDomainPath, "PowerSurgeMVC");

#-----Import statements---#
. $LeslieAppBasePath\config.ps1
. $LeslieAppBasePath\Models\BlogRepository.ps1
#-------------------------#

if($AppConfig.Logging -eq $true) {
	. $LeslieAppBasePath\core\Logging.ps1
	
	#Create the LeslieMVC.ps1 Logger, using the currently executing file as the logger's name. (
	$logger = Create-Log4NetLogger $MyInvocation.MyCommand.Name;	#logging is currently configured to use MSSQL database and not files.

	$logger.Debug([string]::Concat($items['RequestID'], ": Welcomew to Leslie MVC!"));
	$logger.Debug([string]::Concat($items['RequestID'], ": LeslieMVC core initialised for new web request.."));
}

function Incoming-Request {
	. $LeslieAppBasePath\App.ps1
    Import-Module $LeslieAppBasePath\core
	Initialize-App
	 Route-Request $request.rawURL
	New-Request $request.rawURL
}
