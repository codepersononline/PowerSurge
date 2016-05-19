. .\TestSetup.ps1
Import-Module "$PowerSurgeMVCPath\core\ViewLoader.psm1";

Describe 'ViewLoader Get-ViewFilesInFolder' {

    It 'should pass' {
        $results = Get-ViewFilesInFolder '' ''

        $results | Should Be $true 
    }

    It 'should fail' {
        $results = Get-ViewFilesInFolder '' ''

        $false | Should Be $true 
    }
}
