REMOVE-Module URL
Import-Module $PSScriptRoot\URL.psm1 -DisableNameChecking

InModuleScope URL{
	Describe 'Fixing up URLs' {
		Context 'When I pass in a URL string' {
	
			It 'should always trim the first slash' {
				Trim-FirstAndLastSlashesOnURL -rURL '/yourURL' | Should be 'yourURL'
			}
			It 'should always trim the last slash' {
				Trim-FirstAndLastSlashesOnURL -rURL 'yourURL/' | Should be 'yourURL'
			}
			It 'should always return the original string if no slashes in' {
				Trim-FirstAndLastSlashesOnURL -rURL 'yourURL' | Should be 'yourURL'
			}
			It 'should always return an empty string if // given' {
				Trim-FirstAndLastSlashesOnURL -rURL '//'| Should be ''
			}
			It 'should always return an empty string if // given' {
				Trim-FirstAndLastSlashesOnURL -rURL ' ' | Should be ' '
			}
		}
	}
	Describe 'Validating URLs' {
		Context 'when a URL is given' {
			It 'succeeds if a well formed URL is given' {
				Validate-URL -inputURL '/dfnijsdf/' | should be $true
			}
			It 'falis if a string with a space is given' {
				Validate-URL -inputURL '/dfn ijsdf/' | should be $false
			}
			It 'succeeds if a string with a number is given' {
				Validate-URL -inputURL 'dfnijsdf9' | should be $true
			}
			It 'succeeds if a string with multiple URL sections are given' {
				Validate-URL -inputURL '/sdfds/sdfsd/dfss/4/AZ' | should be $true
			}
			It 'succeeds if a string with multiple URL sections are given' {
				Validate-URL -inputURL '/sdfds/sdfsd/dfss/4/AZ' | should be $true
			}
			It 'succeeds if a string containing a dash is given' {
				Validate-URL -inputURL 'sdfds-yy' | should be $true
			}
			It 'fails if a string containing a backslash is given' {
				Validate-URL -inputURL 'sdfds\yy' | should be $false
			}
		}
	}
}