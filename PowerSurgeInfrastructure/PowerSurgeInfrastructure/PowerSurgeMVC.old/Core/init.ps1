#This file exists because to run the Start-PowerSurge function from ASP.NET, we have to invoke the powersurgeMVC.ps1 script twice - once to discover the functions, and then a second time to execute it.
#unfortunately this created issues when using constant variables as powershell would complain that the variables were already created and couldn't be overwritten.
#as a workaround, I created this file as a wrapper, which seems to work ok for the moment. 

function Init-PowerSurgeEnvironment {
    param(
        [System.Web.HttpRequest]$request,
        [System.Web.HttpResponse]$response,
        [string]$AppDomainPath
    )

    . "$AppDomainPath\PowerSurgeMVC\core\powersurgeMVC.ps1"
    Start-PowerSurge $request $response $AppDomainPath
}