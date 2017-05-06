param(
	$script:websitePath,
	$script:invokedControllerName, 
	$script:invokedActionName
)

function Find-View {
param(
	[string]$ViewName,
	[string]$WebsitePath = $script:websitePath,
	[string]$ControllerName = $script:InvokedControllerName
)   
	New-Variable -Option Constant -Name 'viewFolderPath' -Value ([string]"$WebsitePath\Views\")
	New-Variable -Option Constant -Name 'viewSubfolderPath' -Value ([string]"$viewFolderPath\$ControllerName")
	New-Variable -Option Constant -Name 'fileNameToBeFoundHTML' -Value ([string]::Concat($ViewName,'View.html'))
	New-Variable -Option Constant -Name 'fileNameToBeFoundPS1' -Value ([string]::Concat($ViewName,'View.ps1'))

	if([System.IO.File]::Exists("$viewSubfolderPath\$fileNameToBeFoundHTML")){
		return @(1,"$viewSubfolderPath\$fileNameToBeFoundHTML");
	}
	
	elseif([System.IO.File]::Exists("$viewSubfolderPath\$fileNameToBeFoundPS1")){
		return @(2,"$viewSubfolderPath\$fileNameToBeFoundPS1");
	}

	elseif([System.IO.File]::Exists("$viewFolderPath\$fileNameToBeFoundHTML")){
		return @(1,"$viewFolderPath\$fileNameToBeFoundHTML");
	}
	
	elseif([System.IO.File]::Exists("$viewFolderPath\$fileNameToBeFoundPS1")){
		return @(2,"$viewFolderPath\$fileNameToBeFoundPS1");
	}
	else {
		throw 'View Cannot be found!'
	}
}

function Global:Render-View {
param(
    [string] $ViewName = 'Global',
    [hashtable] $ViewData = $null
) 
    . $websitePath\core\ViewHelperFunctions.ps1;
	
	$defaultGlobalViewFilePath = @(0,"$Script:WebsitePath\views\GlobalView.pshtml") 
	#0 indicates that the file is 'text based, and will need to be converted into a scriptblock before running. 
	# array format matches what is normally returned from the Find-View function: we need to know the type of 
	#file that exists on disk, so that we can determine in this function, whether to need to turn the 'text file' into PowerShell code.
	
	$globalViewExists = $false; 
	
	if(($ViewName -eq 'Global') -and ([System.IO.File]::Exists($defaultGlobalViewFilePath ))) { #short circuit for gloabl view
		$globalViewExists = $true;
		$ViewFilePath = $GlobalViewFilePath
	} 
	else{	
		$ViewFilePath = Find-View -ViewName $ViewName -Websitepath $script:websitePath 
	}
	
	if (@($ViewFilePath).Count -eq 0) {
		return "No matching view called `'$ViewName`' found in folders \Views\$controllerName\ or \Views\"
	}
    else {
				
		$content = Render-PartialView -ViewName $script:invokedActionName -ViewData $ViewData
		
		if($ViewFilePath[0] -eq 1) {#found .html view
				$ViewContent = [string]::Concat("@`"`n",([System.IO.File]::ReadAllText($ViewFilePath[1], [System.Text.Encoding]::UTF8 )),"`n`"@")
				return [scriptblock]::Create($ViewContent).Invoke()
		}
		elseif($ViewFilePath[0] -eq 2){ ##found .ps1 view
			return (. $ViewFile[1])
		}
	}
}
function Global:Render-PartialView {
param(
    [string] $ViewName = $script:invokedActionName,
    [hashtable] $ViewData = $null,
	[string] $SubFolderName = $script:invokedControllerName
)
	DEBUG "Viewname: $viewName"
	DEBUG "ControllerName: $controllerName"
	DEBUG "ViewData: $ViewData"

    . $websitePath\core\ViewHelperFunctions.ps1;

	New-Variable -Name ViewFilePath -Option Constant -Value (
		Find-View -ViewName $ViewName -Websitepath $websitePath -SubFolderName $ControllerName
	)

	if (@($ViewFilePath).Count -eq 0) {
		return "No matching view called `'$ViewName`' found in folders \Views\$controllerName\ or \Views\"
	}
    else {
		if($viewData -is [hashtable]) {
			foreach($item in $ViewData.getEnumerator()) {
				New-Variable -Name $item.Name -Value $item.Value
			}
		}
			
		if($ViewFilePath[0] -eq 1) {#found .html view
				$ViewContent = [string]::Concat("@`"`n",([System.IO.File]::ReadAllText($ViewFilePath[1], [System.Text.Encoding]::UTF8 )),"`n`"@")
				return [scriptblock]::Create($ViewContent).Invoke()
		}
		elseif($ViewFilePath[0] -eq 2){ ##found .ps1 view
			return (. $ViewFile[1])
		}
	}

}

Export-ModuleMember -Function 'Render-View', 'Render-PartialView'