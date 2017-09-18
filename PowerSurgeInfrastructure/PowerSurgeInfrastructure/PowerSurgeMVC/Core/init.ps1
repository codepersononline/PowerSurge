
<#
.SYNOPSIS
PowerSurge Bootloader

.DESCRIPTION
This file exists because to run the Start-PowerSurge function from ASP.NET, we have to invoke the powersurgeMVC.ps1 script twice - once to discover the functions, and then a second time to execute it.
unfortunately this created issues when using constant variables as powershell would complain that the variables were already created and couldn't be overwritten.
as a workaround, I created this file as a wrapper, which seems to work ok for the moment. 

.PARAMETER Request
The Request parameter is the System.Web.HttpRequest object, injected at runtime by ASP.NET. (once per request)

.PARAMETER Response
The Response parameter is the System.Web.HttpResponse object, injected at runtime by ASP.NET. (once per request)

.PARAMETER AppDomainPath
The AppDomainPath of this IIS website.
#>
function Init-PowerSurgeEnvironment {
[cmdletbinding()]
param(
    [System.Web.HttpRequest]$Request,
    [System.Web.HttpResponse]$Response,
    [string]$AppDomainPath
)
    
    . "$AppDomainPath\PowerSurgeMVC\core\powersurgeMVC.ps1"
    Start-PowerSurge $Request $Response $AppDomainPath
}