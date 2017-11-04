
Set-Variable -Name 'logging' -Value $false -Option Constant;
#uncomment the following line if you wish to have DB support
 #. $PowerSurgeAppPath\core\DB.ps1

[string] $debugString = 'Debug Info: ';

$Global:AppConfig = @{
    'ApplicationName' = 'PowerSurge MVC';
    'Logging' = $false;
    'Debugging' = $false;
    'DBConnectionString' = '';
    'UseGlobalView' = $true;
}