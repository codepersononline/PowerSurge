$Controller = New-Module -Name 'ModuleController' {

	function AboutMe {
        '<!DOCTYPE html><html><title>About Me</title><body>
		<h1>Hello!</h1>
		<p>Welcome to my homepage, this is just a test...</p>
		</body></html>'
	}

	function EmbeddedStaticFileTest {
		"<!DOCTYPE html>
		<html>
			<head>
				<title>embedded_static_file_test</title>
				<link rel=""stylesheet"" type=""text/css"" href=""$baseURL/PowerSurgeMVC/static/css/test.css"" />
				<script type=""text/javascript"" src=""$baseURL/PowerSurgeMVC/static/scripts/test.js""></script>
			</head>
			<body>
				<h1>embedded_static_file_test</h1>
				<img src=""$baseURL/PowerSurgeMVC/static/images/meme.jpg"" />
			</body>
		</html>"
	}

	function AddTwoNumbers { 
	param(
		$firstNumber = 0, 
		$secondNumber = 0
	)
    
		try{$firstNumber = [convert]::ToInt32($firstNumber)
			$secondNumber = [convert]::ToInt32($secondNumber)
		}
		catch{return "<html><head></head><body><h2>One of the parameters couldn't be converted to an int</h2><body></html>"}
   
			return "
			<html>
				<head></head>
				<body>
					<h2>$($firstNumber + $secondNumber)</h2>
			</body>
			</html>"
	}

	function Download {
		$filename = 'meme.jpg'

		$response.AddHeader('Content-Disposition', "attachment;filename=$filename");
		$response.ContentType = 'image/jpeg'
		$response.TransmitFile("$baseURL/PowerSurgeMVC/PowerSurgeMVC/static/files/$filename")
	}

	function SimpleForm {

		Render-View 
	}

	function FireFoxProcess  {
		Import-Module "$PSScriptRoot\..\Models\ProcessModel\ProcessModel.psm1"
		
		$data = Get-AllFireFoxProcesses | select ID, Name
		#Get-AllFireFoxProcesses | select ID, Name |ConvertTo-Csv -NoTypeInformation

		Render-View -Viewdata @{'processstuff'=$data}
	}

	Export-ModuleMember -Function *
} -AsCustomObject 
