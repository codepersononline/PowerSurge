
$Controller = New-Module -Name 'MonitoringController' {
param($response)
	Function Index { 
		'<!DOCTYPE html><html><head><link rel=""shortcut icon"" href=""//cdn.sstatic.net/stackoverflow/img/favicon.ico""/><meta charset=""utf-8""><title>Title of the document</title></head><body><h1>Hello World from MonitoringController Index function!</h1><body></html>';
	} 
	 
	Function ProcessesHTML { 
		 "<!DOCTYPE html><html><head></head>
			<body><h1>Processes, in a table!</h1> 
				$(Get-Process | Select-Object Name,Handles,VM,WS,PM,NPM,Path,Company,CPU | ConvertTo-Html)
			<body></html>";
	}

	Function ProcessesJSON {
		Get-Process |
			Select-Object Name, Handles, VM, WS, PM, NPM, Path, Company, CPU |
			ConvertTo-JSON -Compress -ErrorAction SilentlyContinue;
	}
	
	Function ServicesJSON  { 
		$response.ContentType = 'application/json';
		$response.AddHeader('Access-Control-Allow-Origin', '*') #enable CORS

		return (get-service | select Status, Name, DisplayName | ConvertTo-JSON -compress).ToString();
	}
	
	Function ProcessesXML {	
		$response.ContentType = "text/csv";
		$response.AddHeader("content-disposition", "attachment;filename=test.csv");
		$res =  Get-Process | Select-Object Name,Handles,VM,WS,PM,NPM,Path,Company,CPU | ConvertTo-Csv -NoTypeInformation  
		$res | %{$_ + "`n"}
	}

	Export-ModuleMember -Function *;
} -AsCustomObject -ArgumentList $global:response