#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
#. "$here\$sut"
. .\TestSetup.ps1
#$PowerSurgeAppPath = 'C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\PowerSurgeMVC'; # Mock the path as it appears in the app, so that the findView function will work.

Import-Module "$PowerSurgeMVCPath\core\Loaders.psm1";
. "$PowerSurgeMVCPath\core\ViewHelperFunctions.ps1";
. "$PowerSurgeMVCPath\Controllers\MockController.ps1";
#. C:\myCode\GitHub\PowerShell\StartingFromScratch\StartingFromScratch\LeslieMVC\Controllers\HomeController.ps1

Describe 'MockController' {

    It 'Invoke the MockController index function' {
        $page = $MockController.Index()
        $page.Length 
        ($page.Length -gt 5) | Should Be $true 
    }
}
