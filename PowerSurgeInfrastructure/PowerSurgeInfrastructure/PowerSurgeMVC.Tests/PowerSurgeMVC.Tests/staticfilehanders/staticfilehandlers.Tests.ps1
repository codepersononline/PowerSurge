$URL = 'http://localhost:60453/'
Describe 'Static File Handlers'{

    Context 'When loading a text file' {
        It 'should return the file contents when at the root level' {
                Invoke-WebRequest 'http://localhost:60453'
        }
    }
}
<#
Context 'When loading an html file' {}
Context 'When loading a css file' {}
Context 'When loading a js file' {}
}#>