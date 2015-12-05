#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
#. "$here\$sut"
. .\TestSetup.ps1
$LeslieAppBasePath = "C:\myCode\GitHub\PowerShell\StartingFromScratch\StartingFromScratch\LeslieMVC"; # Mock the path as it appears in the app, so that the findView function will work.

. "$LeslieProjectPath\core\Loaders.ps1";
. "$LeslieProjectPath\core\ViewHelperFunctions.ps1";
. "$LeslieProjectPath\Controllers\HomeController.ps1";

#. C:\myCode\GitHub\PowerShell\StartingFromScratch\StartingFromScratch\LeslieMVC\Controllers\HomeController.ps1
Describe "HomeController" {

    It "Invoke the home controller" {
        $page = $HomeController.Index()
        $page.Length 
        ($page.Length -gt 5) | Should Be $true 
    }
}
