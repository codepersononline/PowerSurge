#Application specific settings only!
Set-Variable -Name 'logging' -Value $false -Option Constant;
#uncomment the following line if you wish to have DB support
 #. $PowerSurgeAppPath\core\DB.ps1

$global:steve = 31;
[string]$debugString = 'Debug Info: ';

$global:AppConfig = @{
    'ApplicationName' = "Steve's MVC App!";
    'Logging' = $false;
    'Debugging' = $false;
    'DBConnectionString' = 'Data Source=.\SQLEXPRESS;Integrated Security=SSPI;Initial Catalog=LeslieMVCBlog';
    'UseGlobalView' = $true;
    'defaultRoute' ='/Mock/Index'
}



