@"
<html>
		<head>
		$(Css 'main.css')
		</head>
		<body>
		<div id="page">
		<p id="login">
		$( 
			if($session['loggedin'] -eq $true) { 
				"Hi, you are currently logged on as: <b>$($session['firstname'])!</b> Click <a href=""/Mock/Logout"">Here</a> to log out.</p>"
			}
		)
		
"@		