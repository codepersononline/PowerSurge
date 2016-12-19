$PowerSurgeURL = 'http://localhost:60453';

cd $PSScriptRoot

if(Test-Path '..\..\..\PowerSurgeMVC\PowerSurgeMVC\Controllers\') {
    Copy-Item `
        -Path .\TestData\CustomHeaderController.ps1 `
        -Destination ..\..\..\PowerSurgeMVC\PowerSurgeMVC\Controllers\ 
}

if(Test-Path '..\..\..\PowerSurgeMVC\PowerSurgeMVC\') {
        
        Copy-Item `
            -Path .\TestData\routes.ps1 `
            -Destination ..\..\..\PowerSurgeMVC\PowerSurgeMVC\ 
}

Describe 'CustomHeaderController - Send an HTTP request to the CustomHeaderController with an arbitrary key value pair.' {
    $headerKey = 'steve';
    $headerValue = 'rathbone';
    
    $ResponseHeaders = Invoke-WebRequest  `
        -Uri "$PowerSurgeURL/insertcustomheader/$headerKey/$headerValue" |
            Select-Object -ExpandProperty Headers

    It "Then checks in the HTTP response that the Header key '$headerKey' was returned." {
         
        $ResponseHeaders.ContainsKey($headerKey) | Should Be $true 
    }

    It "Then checks in the HTTP response that the Header value '$headerValue' was returned." {
   
        $ResponseHeaders.ContainsValue('rathbone') | Should Be $true 
    }
    It "Then checks in the HTTP response that the Header value '$headerKey' matches header value '$headerValue'." {
   
        $ResponseHeaders.$headerKey| Should be $headerValue 
    }
    
    $injectedControllerPath = '..\..\..\PowerSurgeMVC\PowerSurgeMVC\Controllers\CustomHeaderController.ps1'
    
    if(Test-Path -Path $injectedControllerPath) {
        Remove-Item -Path $injectedControllerPath -Force;
    }
}

Describe 'RouteInjection' {
    It 'Injects a route into the route table' {
    

    }
}


