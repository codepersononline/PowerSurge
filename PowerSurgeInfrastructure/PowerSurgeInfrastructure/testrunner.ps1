#PS1 script to run all integeration tests.

Set-StrictMode -Version 'Latest';

$URL = 'http://localhost:60453'

<#
.SYNOPSIS
    Copy a specific routes.ps1 file used by the integration tests to the PowersurgeMVC application folder.
#>
function Copy-RouteFile {
    if ( Test-Path -Path '.\PowerSurgeMVC\routes.ps1') {
        Write-Output "Now backing up file .\PowerSurgeMVC\routes.ps1 as routes.temp.ps1, before copying routes.ps1...";
        Rename-Item -Path '.\PowerSurgeMVC\routes.ps1' -NewName 'routes.temp.ps1';
        Write-Output 'Done.';
        Copy-Item -Path '.\PowerSurgeMVC.Integration.Tests\routes.ps1' -Destination .\PowersurgeMVC\routes.ps1  
    }
    else {
        throw "Copy-RouteFile: Test path failed! could not find .\PowerSurgeMVC\routes.ps1"
    }
}
function Restore-RouteFile {
   #Get-Location "$PowerSurgeFolderPath\routes.temp.ps1"
    if (Test-Path -Path "C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\PowerSurgeMVC\routes.temp.ps1") {
        Write-Output "Now restoring file .\PowerSurgeMVC\routes.temp.ps1 as routes.ps1..";
        Rename-Item -Path ".\PowerSurgeMVC\routes.temp.ps1" -NewName "routes.ps1" -Force
        Write-Output 'Done.'; 
    }
    else {
        throw "Restore-RouteFile: Test path failed! could not find .\PowerSurgeMVC\routes.tmep.ps1 and routes.temp.ps1"
    }
}

Copy-RouteFile;
#Restore-RouteFile;
Write-host "$(Get-Location)";
Invoke-Pester