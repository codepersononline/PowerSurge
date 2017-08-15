$Controller = New-Object -TypeName PSObject

$Controller | Add-Member -PassThru -MemberType ScriptMethod Index -Value { 
    '<h1>Hello World from PSObjectController Index function!</h1>';
}

$Controller | Add-Member -MemberType ScriptMethod -Name "AboutMe" -Value { 
	'<html><title>About Me</title><body>
	<h1>Hello!</h1>
	<p>Welcome to my homepage, this is just a test...</p>
	</body></html>'
}

$Controller | Add-Member -MemberType ScriptMethod -Name "AddTwoNumbers" -Value  { 
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

$Controller | Add-Member -MemberType ScriptMethod -Name "Download" -Value  {
param()
	$filename = 'meme.jpg'

		$response.AddHeader('Content-Disposition', "attachment;filename=$filename");
		$response.ContentType = 'image/jpeg'
		$response.TransmitFile("$baseURL/PowerSurgeMVC/static/files/$filename")
}

$Controller | Add-Member -PassThru -MemberType ScriptMethod SimpleForm -Value { 	
    Get-View -ViewData @{'steve' = 'rathbone'}
} 

$Controller | Add-Member -PassThru -MemberType ScriptMethod GetUser -Value { 
    param(
        $id, 
        $name
    )

    if (Is-HttpGET) {

        $ViewHashTable = @{
            'ValidationErrors'       = $false;
            'ValidationErrorMessage' = '';
        }

        try { $id = [convert]::ToInt32($id) }
        catch { 
            $ViewHashTable.ValidationErrors = $true
            $ViewHashTable.ValidationErrorMessage = "$id couldn't be converted to an int" 
            #TODO: make 'production mode' work, so that stacktraces can be turned off.
        }
    
        if ($id -gt 0) {
            Get-View -ViewData $ViewHashTable
        }
        else {
            $ViewHashTable.ValidationErrors = $true
            $ViewHashTable.ValidationErrorMessage = 'We need a postive number champ.'
            Get-View -ViewData $ViewHashTable
        }
		
    }
    else {
        $response.StatusCode = 401;
    }
    
} 

#http://stackoverflow.com/questions/3441735/detect-ajax-call-asp-net
$Controller | Add-Member -PassThru -MemberType ScriptMethod ShowAJAXForm -Value { 	
    $HTMLString = "
	 $(Script 'jquery-1.11.2.js') 
		<h1>An Ajax form posting example!</h1>
	
			Name: <input type=""text"" name=""searchbox"" id=""searchbox"">
			<input type=""button"" id=""button"" value=""Go"">
		
		<div id=""page""></div>
	<script>
	`$(document).ready(function() {
		`$(""#button"").click(function(){
		  $.post(""$($baseURL)/Mock/getajaxresponse"",`$('#searchbox'),
		  function(data,status){
			 //alert(""Data: "" + data + ""\nStatus: "" + status);
				`$(""#page"").append(data)
		  });
		});
	});
	</script>";
	
    $HTMLString = [string]::Concat($HTMLString, "<p>Hi there, please enter your name into the text field above.</p>" )
    return $HTMLString
}  

$Controller | Add-Member -PassThru -MemberType ScriptMethod Getajaxresponse -Value { 
	
    if (Request-HTTPAJAX) {	
        return ('<p>Hi ' + $request['searchbox'] + "! the current date and time on the server is: <b>$([datetime]::Now)</b></p>")
    }
    else {
        return 'function is only accessable via AJAX.'
    }
	
}

$Controller | Add-Member -PassThru -MemberType ScriptMethod Count -Value { 
    if ($session['count'] -eq $null) { $session['count'] = 0; }
    $response = "<!DOCTYPE html><html>
	<head>
		<link rel=""shortcut icon"" href=""//cdn.sstatic.net/stackoverflow/img/favicon.ico""/>
		</head><body>
			<h1>counter was: $($session['count'])</h1>";
    $session['count'] += 15;
    $response += "<h1>counter is: $($session['count'])</h1></body></html>";
	
    return $response;
} 


$Controller | Add-Member -PassThru -MemberType ScriptMethod Login -Value { 
    if ($session["loggedin"] -eq $null) { $session["loggedin"] = $false; } #if the variable doesn't exist, create it and set it to false...

    if ($session["loggedin"] -eq $false) {
        $content = '<h2>You are not logged in:</h2>
		Please enter your username and passowrd:
		<form action="' + $baseURL + '/Mock/LoginProcess/" method="post">
			First name: <input type="text" name="firstname"><br>
			Last name: <input type="text" name="lastname">
			<input type="submit" value="Submit">
		</form>'
    }
    else {
        $content = "<h2>You are already logged in!</h2>"
    }
 
		
    return $content;
}

$Controller | Add-Member -PassThru -MemberType ScriptMethod LoginProcess -Value {
    if ($session['loggedin'] -eq $false) { $session['loggedin'] = $true; } #if the variable doesn't exist, create it and set it to false...
	
    $session['firstname'] = $request.Form['firstname']
    $session['userRole'] = "User"
    if ($request.Form['firstname'] -eq 'Toby') { $session['userRole'] = 'Administrator' }
    if ($request.Form['firstname'] -eq 'Steve') { $session['userRole'] = 'Super User' }
    #$response.Redirect($baseURL); 
	
    return "Hi $($request.Form['firstname']), you are now logged in as $($session['userRole'])"; 
}

$Controller | Add-Member -PassThru -MemberType ScriptMethod -Name Logout -Value {
    if ($session['loggedin'] -eq $true) { $session['loggedin'] = $null; } #if the variable doesn't exist, create it and set it to false...
    $session.Clear();
	
    return 'You have now been logged out.'; 
}

$Controller | Add-Member -PassThru -MemberType ScriptMethod -Name Download -Value {
    param(
        [string]$filename
    )	
    $filename = 'meme.jpg'

    $response.AddHeader('Content-Disposition', "attachment;filename=$filename");
    $response.ContentType = 'image/jpeg'
    $response.TransmitFile("$baseURL/PowerSurgeMVC/static/files/$filename")
}