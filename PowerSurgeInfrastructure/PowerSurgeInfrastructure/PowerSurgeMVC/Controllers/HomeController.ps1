$HomeController = New-Object –TypeName PSObject

$HomeController | Add-Member -MemberType ScriptMethod -Name "Index" -Value { 
 
	Get-View "header"
	Get-View "menu"
    
    #'<h1> you have been diverted to the default route...</h1>
    #<img src="./LeslieMVC/static/images/meme.jpg">'

    get-view "footer"
}

$HomeController | Add-Member -MemberType ScriptMethod -Name "findUser" -Value { 
    param(
        $userID
    )
    $response = "<html><head></head><body><h1>FindUser action has been called with ID $userID</h1><body></html>"
    return $response;
} 

#return $HomeController;


#wrappers
function Home-Index {
    $HomeController.Index()
}
function Home-FindUser {
param($id)
    $HomeController.findUser($id)
}



