$PowerSurgeMVCPath = 'C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\PowerSurgeMVC\PowerSurgeMVC'
cd $PowerSurgeMVCPath
Import-Module "$PowerSurgeMVCPath\core\ViewLoader.psm1";

Describe 'ViewLoader Get-ViewFilesInFolder' {

    It 'should pass' {
        $results = Get-ViewFilesInFolder '' ''

        $results | Should Be $true 
    }

    It 'should fail' {
        $results = Get-ViewFilesInFolder '' ''

        $results | Should Be $true 
    }
}
