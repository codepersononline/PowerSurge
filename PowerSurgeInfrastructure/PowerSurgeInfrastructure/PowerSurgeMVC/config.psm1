#Application specific settings only!
Set-Variable -Name 'logging' -Value $false -Option Constant;
#uncomment the following line if you wish to have DB support
 #. $PowerSurgeAppPath\core\DB.ps1

$global:steve = 31;
[string]$debugString = 'Debug Info: ';

$global:AppConfig = @{
    'ApplicationName' = 'PowerSurge MVC';
    'Logging' = $false;
    'Debugging' = $false;
    'DBConnectionString' = '';
    'UseGlobalView' = $true;
    'defaultRoute' ='/Home/Index'
}



