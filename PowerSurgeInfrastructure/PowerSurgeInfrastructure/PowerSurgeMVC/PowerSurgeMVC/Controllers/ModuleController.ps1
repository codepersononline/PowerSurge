$ModuleController = New-Module -Name 'ModuleController' {

	function AboutMe {
		'<html><title>About Me</title><body>
		<h1>Hello!</h1>
		<p>Welcome to my homepage, this is just a test...</p>
		</body></html>'
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
		Get-View 
	}

	Export-ModuleMember -Function *
} -AsCustomObject 