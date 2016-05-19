$TempController = New-Object –TypeName PSObject

$TempController = $TempController | Add-Member -PassThru -MemberType ScriptMethod Index -Value { 
    $response = "<html><head></head><body><h1>Hello World from TempController from Steve</h1><body></html>"
    return $response;
}