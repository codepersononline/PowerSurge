<#
27/09/2014 Steve R.
Welcome to PowerSurge.
#>
set-strictmode -version Latest;
Set-Variable -name 'LeslieAppBasePath'  -Value ([string]"$AppDomainPath\PowerSurgeMVC")                 -Option Constant -Force;
Set-Variable -name 'baseURL'            -Value $Request.Url.GetLeftPart([System.UriPartial]::Authority) -Option Constant -Force;

[psvariable[]]$Global:allvars = $null

$AppDomainPath = ''
#Are we running in IIS? if yes, the AppDomainPath variable will be injected from ASP.NET.
#Otherwise we will need to set it manually so we can edit these files in ISE/Visual Studio...
if([string]::IsNullOrEmpty($AppDomainPath)) {
    $AppDomainPath = "C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\"
}

. $LeslieAppBasePath\config.ps1


#this test may be redundant.. otherwise it may be possible to move it all the way out into the Global.asax file eg into the Application_Start() method
# so we only have to do this check once at startup.
if(Test-Path $LeslieAppBasePath -IsValid) { 

    if($AppConfig.Logging -eq $true) {
	    . $LeslieAppBasePath\core\Logging.ps1
	
	    #Create the LeslieMVC.ps1 Logger, using the currently executing file as the logger's name. (
	    $logger = Create-Log4NetLogger $MyInvocation.MyCommand.Name;	#logging is currently configured to use MSSQL database and not files.

	    $logger.Debug([string]::Concat($items['RequestID'], ": Welcomew to Leslie MVC!"));
	    $logger.Debug([string]::Concat($items['RequestID'], ": LeslieMVC core initialised for new web request.."));
    }

    function Incoming-Request {
	    #-----Import statements---#
    . $LeslieAppBasePath\core\config.ps1
    . $LeslieAppBasePath\core\URL.ps1
    . $LeslieAppBasePath\core\ViewHelperFunctions.ps1
    . $LeslieAppBasePath\core\securityutilityfunctions.ps1
    . $LeslieAppBasePath\core\RoutingClassic.ps1  
    
    
    #-------------------------#

        . $LeslieAppBasePath\App.ps1
	    Initialize-App
        $funcs = (Get-ChildItem FUNCTION:\)
        $Global:allvars = get-variable
        #return $str + ($funcs | %{$_.Name.ToString() +'<BR/>'})
	    Route-Request $request.rawURL
        #return '<div id="footer">footer content</div>'
    }

}

function dumpVariablesToHTMLTable {
    $vars = $Global:allvars
    $str = $vars.count.ToString();
    
    for($i=0; $i -lt $vars.count;$i++) {
      $str += $vars[$i].Name + $vars[$i].Value +'</br>'
    }
    return $str;
}
