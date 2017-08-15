$domain = '.fritz.box';
$environments = @(); 

#$environments += [psobject] @{
#    Name       = 'rathbone-mbp';
#    IPAddress  = '192.168.178.39';
#    Credential = (Get-Credential)
#} 

$environments += [psobject] @{
    Name       = 'WIN-5FK1L1T4IPU';
    IPAddress  = '192.168.178.38';
    Credential = (Get-Credential)
} 
function Prepare-AppForDeployment {
   Get-ChildItem '\Users\steve\Documents\GitHub\PowerSurge' -Recurse;
}
function Test-ConnectionsToLocalEnvironments {
    param(
        [Parameter(ValueFromPipeline = $true)] $Environment
    )

    begin {
        if ($Environment.IPaddress) {throw 'IPAddress param cannot be null or empty';}   
    }
   
    process {
        if ((Test-Connection -Quiet $Environment.Name -Count 1) -eq $false) {
            throw $Environment.Name + ' is offline';
        }
        else {Write-Host -ForegroundColor Green  "$($Environment.Name) is online!";}
    }

    end {} 
}

#check that all environments are up and respond to ping
#we dont test azure server here because ICMP service is not enabled on the remote server
#$environments | 
#    Test-ConnectionsToLocalEnvironments 

function Make-IIS7Environment {
param(
    $Environment
)
    Write-Host "now connecting to: $($environment.name)";
    Invoke-Command -credential (Get-Credential) -ComputerName ($environment.name) -ScriptBlock {
        Import-Module WebAdministration;

        $WebsiteName = 'PowerSurgeMVC';
        mkdir "c:\$WebsiteName";
        New-WebAppPool -Name $WebsiteName -Force;
        Set-Location IIS:\AppPools\;
        Get-Item ".\$WebsiteName" | Set-ItemProperty -Name managedruntimeversion -Value 'v4.0' -Force;
        Restart-WebAppPool ".\$WebsiteName\";
        New-Website -Name $WebsiteName -Port '80' -PhysicalPath "c:\$WebsiteName" -ApplicationPool $WebsiteName -Force;
        "Deployment: $(get-date)" | Out-File "c:\$WebsiteName\build.html";
    } 
}
function Destroy-IIS7Environment {
param(
    $Environment
)
    Write-Host "now connecting to: $($environment.name)";
    
    Invoke-Command -credential (Get-Credential) -ComputerName ($environment.name) -ScriptBlock {
        Import-Module WebAdministration;

        $WebsiteName = 'PowerSurgeMVC';
        
        if(Test-Path "IIS:\Sites\$WebsiteName") {Remove-Website -Name $WebsiteName;}
        else {Write-Host "website IIS:\Sites\$WebsiteName does not exist." -ForegroundColor Green}
        
        if(Test-Path "IIS:\AppPools\$WebsiteName") {Remove-WebAppPool -Name $WebsiteName;}
        else {Write-Host "app pool IIS:\AppPools\$WebsiteName does not exist." -ForegroundColor Green}
        
        if(Test-Path "c:\$WebsiteName") {Remove-Item "c:\$WebsiteName" -Recurse -Force;}
        else {Write-Host "Folder c:\$WebsiteName does not exist." -ForegroundColor Green}
    }
}
    
#Make-IIS7Environment -Environment $environments[0];
#Destroy-IIS7Environment $environments[0];

write-host "Now running make iis environment with $($environments[0])"
Make-IIS7Environment -Environment $environments[0];
Destroy-IIS7Environment $environments[0];

Copy-Item