#Application specific settings only!

$steve = 31
#-----Variables----#
[string]$debugString="Debug Info: ";
$ControllerCollection = @{};
$baseURL = $Request.Url.GetLeftPart([System.UriPartial]::Authority)
$defaultRoute = "/Home/Index"

#-----------------

# validURLChars is the list of allowable of characters in the URL... change this if you wish, but be aware of the dangers..
$Script:validURLChars = [regex]'^[a-z0-9~%.:_\-]+$'

Set-Variable -Name "LOGGING" -Value $false -Option Constant;

$routes = @(
    "{controller}/{action}",
    "{controller}/{action}/{id}",
    "{controller}/{product}/{action}/{id}"
); #holds all the routes that the request will be validated against..

$AppConfig = @{
    "Logging" = $false;
    "DBConnectionString" = "Data Source=.\SQLEXPRESS;Integrated Security=SSPI;Initial Catalog=LeslieMVCBlog";
    "UseGlobalView" = $true;
}