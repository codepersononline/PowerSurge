#IMPORTANT!! make sure that ASP.NET 4.5 or above is installed on the server.
#if it is not installed, you will get HTTP 500 error pages.
#to install ASP.NET 4.5, run 'Install-WindowsFeature Web-Asp-Net45'
#Add-PSSnapin WDeploySnapin3.04

$serverCore2016IPAddress = '192.168.178.38';
#$credentials = Get-Credential;

Invoke-Command `
    -ComputerName $serverCore2016IPAddress `
    -Credential $credentials `
    -ScriptBlock {
        
        Install-WindowsFeature Web-Asp-Net45;

        $websitesRootPath = 'C:\Websites';
        $appPoolName = 'PowerSurgeAppPool';
        $websiteName = 'PowerSurgeWebSite';
        $webApplicationName = 'PowerSurgeWebApp';

        if((Test-Path "$websitesRootPath\$websiteName") -eq $false) 
            {New-Item -ItemType Directory -Path "$websitesRootPath\$websiteName\$webApplicationName";}
        
        Import-Module WebAdministration;

        if(Test-Path IIS:\AppPools\PowerSurgeAppPool) 
            {Remove-WebAppPool `
                -Name $appPoolName `
                -ErrorAction Stop;}

        New-WebAppPool `
            -Name $appPoolName `
            -ErrorAction Stop;

        New-Website `
            -Name $websiteName `
            -IPAddress '192.168.178.38' `
            -Port 80 `
            -PhysicalPath "$websitesRootPath\$websiteName" `
            -ApplicationPool PowerSurgeAppPool;
        
        #'<html><head></head><body><h1>It Works!</h1></body></html>' | 
           # Set-Content "$websitesRootPath\$websiteName\index.html"
        
        New-WebApplication `
            -Name PowerSurgeApp `
            -Site PowerSurgeWebsite `
            -PhysicalPath "$websitesRootPath\$websiteName\$webApplicationName" `
            -ApplicationPool PowerSurgeAppPool;

        Enable-WebRequestTracing `
            -Name PowerSurgeWebSite `
            -MaxLogFiles 60 `
            -Directory c:\MyFailedReqLogFiles;
        
        Start-WebAppPool `
            -Name $appPoolName;

        Start-Website `
            -Name PowerSurgeWebSite;
    };

function Remove-PowerSurgeWebSite {
param(
    [parameter(Mandatory=$true)] $UserCreds,
    [parameter(Mandatory=$true)] $ServerIP
)
    
    Invoke-Command `
        -ComputerName $serverIP `
        -Credential $UserCreds `
        -ScriptBlock {
            $websitesRootPath = 'C:\Websites';
            $appPoolName = 'PowerSurgeAppPool';
            $websiteName = 'PowerSurgeWebSite';
            $webApplicationName = 'PowerSurgeWebApp';

            Remove-WebApplication `
                -Name $webApplicationName `
                -Site $websiteName;

            Remove-Website `
                -Name $websiteName;
        
            Remove-Item `
                -Path "$websitesRootPath\$websiteName" `
                -Recurse `
                -Force;

            Remove-WebAppPool `
                -Name $appPoolName;

        }
        
}
<# THIS FUNCTION WORKS! highlight it witht he mouse and then 'run selection' (shift f5)
Remove-PowerSurgeWebSite `
    -UserCreds $credentials `
    -ServerIP $serverCore2016IPAddress 

#>