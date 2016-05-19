param(
    $webAppPath
)

function Initialize-App {
	#your code here!
	#return "App has started."
    . $webAppPath\Models\BlogRepository.ps1
}