function Start-Webserver {
param([string]$path = $(Get-Location))
    $routes = @{
        "/ola" = { return '<html><body>Hello world!$requestUrl.LocalPath</body></html>' }
    }
 
    $url = 'http://localhost:8094/'
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($url)
    $listener.Start()
 
    Write-Host "Listening at $url..."
 
    while ($listener.IsListening)
    {
        $context = $listener.GetContext();
        $response = $context.Response;
        $requestUrl = $context.Request.Url;
        $localPath = $requestUrl.LocalPath;
        $relativefilepath = $localPath.replace('/','\')
       
        Write-Host ''
        Write-Host "> $requestUrl"
        $fullpath = [system.string]::Concat($path, $relativefilepath);
        Write-Host $fullpath 
 
        If (Test-Path $fullpath){ #static file exists
            $extension = [system.io.path]::GetExtension($fullpath)
            $content = "";
            if($extension -eq ".ps1") {$content = . $fullpath }
            else {
                $content =  Get-Content $fullpath 
                
            }
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            
        }
        Else {
          # // static file does not exist
        
            $route = $routes.Get_Item($requestUrl.LocalPath)
  
            if ($route -eq $null)
            {
                $response.StatusCode = 404
            }
            else
            {
                $content = & $route
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
    
            $response.Close()
 
            $responseStatus = $response.StatusCode
            Write-Host "< $responseStatus"
        }
    }
}

