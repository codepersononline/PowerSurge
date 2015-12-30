#Application specific settings only!
Set-Variable -Name 'logging' -Value $false -Option Constant;
Set-Variable -Name 'defaultRoute' -Value '/Home/Index' -Option Constant;
#uncomment the following line if you wish to have DB support
 #. $LeslieAppBasePath\core\DB.ps1

$steve = 31
#-----Variables----#
[string]$debugString="Debug Info: ";
$ControllerCollection = @{};


$routes = @(
    "{controller}/{action}",
    "{controller}/{action}/{id}",
    "{controller}/{product}/{action}/{id}"
); #holds all the routes that the request will be validated against..

$AppConfig = @{
    "Logging" = $false;
    "DBConnectionString" = "Data Source=.\SQLEXPRESS;Integrated Security=SSPI;Initial Catalog=LeslieMVCBlog";
    "UseGlobalView" = $false;
}

