
#uncomment the following line if you wish to have DB support
 #. $PowerSurgeAppPath\core\DB.ps1

$Global:AppConfig = @{
    'ApplicationName' = 'PowerSurge MVC';
    'Logging' = $false;
    'Debugging' = $false;
    'DBConnectionString' = '';
    'UseGlobalView' = $true;
}