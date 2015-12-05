$MonitoringController = New-Object –TypeName PSObject
$MonitoringController | Add-Member -PassThru -MemberType ScriptMethod Index -Value { 
    $response = "<!DOCTYPE html><html><head><link rel=""shortcut icon"" href=""//cdn.sstatic.net/stackoverflow/img/favicon.ico""/><meta charset=""utf-8""><title>Title of the document</title></head><body><h1>Hello World from MonitoringController Index function!</h1><body></html>"
    return $response;
} 

$MonitoringController | Add-Member -PassThru -MemberType ScriptMethod ProcessesHTML -Value { 
    $response = "<!DOCTYPE html><html><head></head>
                <body><h1>Processes, in a table!</h1>
                $(get-process | select Name,Handles,VM,WS,PM,NPM,Path,Company,CPU | ConvertTo-Html)
                <body></html>"
    return $response;
}

$MonitoringController | Add-Member -PassThru -MemberType ScriptMethod ProcessesJSON -Value { 
    
    return get-process | select Name,Handles,VM,WS,PM,NPM,Path,Company,CPU | ConvertTo-JSON -ErrorAction SilentlyContinue
                
   
}

$MonitoringController | Add-Member -PassThru -MemberType ScriptMethod ServicesJSON -Value { 
   
	$response.AddHeader("Access-Control-Allow-Origin", "*") #enable CORS
    return get-service | select Status, Name, DisplayName | ConvertTo-JSON
              
   
}

$MonitoringController | Add-Member -PassThru -MemberType ScriptMethod ProcessesXML -Value { 
    $Response.ContentType = "text/csv";
    $response.Charset = "";   
    
    $Response.AddHeader("content-disposition", "attachment;filename=test.csv");
    $res =  get-process | select Name,Handles,VM,WS,PM,NPM,Path,Company,CPU | ConvertTo-Csv
   # foreach ($row in $res){
     #   $response.write($row)
   # } 
       
    return $res.ToString()       
   
}