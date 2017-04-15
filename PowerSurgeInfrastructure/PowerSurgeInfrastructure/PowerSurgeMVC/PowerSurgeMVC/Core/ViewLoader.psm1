param(
    $script:websitePath,
    $script:invokedControllerName, 
    $script:invokedActionName
)

function Find-View {
param(
    [string]$ViewName,
    [string]$WebsitePath = $script:websitePath,
    [string]$ControllerName = $scriptInvokedControllerName
)   
    New-Variable -Option Constant -Name 'viewFolderPath' -Value ([string]"$WebsitePath\Views\")
    New-Variable -Option Constant -Name 'viewSubfolderPath' -Value ([string]"$viewFolderPath\$ControllerName")
    New-Variable -Option Constant -Name 'fileNameToBeFound' -Value ([string]::Concat($ViewName,"View*"))
    
    if([System.IO.Directory]::Exists($viewSubfolderPath) -eq $false) {
        $viewPathsInParentFolder = Get-ViewFilesInFolder $viewSubfolderPath $fileNameToBeFound
    }
     
    [array]$viewPathsInSubfolder = Get-ViewFilesInFolder $viewSubfolderPath $fileNameToBeFound

    if($viewPathsInSubfolder.Count -gt 0) { #1 or more views were found, but we'll only return the first one in the array.
        return $viewPathsInSubfolder[0];
    }
    else { #view not found in subfolder, now about to look in parent folder $websitePath\Views\ non recursively
        $viewPathsInParentFolder = Get-ViewFilesInFolder "$websitePath\Views\" $fileNameToBeFound
               
        if($viewPathsInParentFolder.Count -gt 0) {
            return $viewPathsInParentFolder[0];
        }
    }
}

function Find-View2 {
param(
    [string]$ViewName,
    [string]$WebsitePath = $script:websitePath,
    [string]$ControllerName = $script:InvokedControllerName
)   
    New-Variable -Option Constant -Name 'viewFolderPath' -Value ([string]"$WebsitePath\Views\")
    New-Variable -Option Constant -Name 'viewSubfolderPath' -Value ([string]"$viewFolderPath\$ControllerName")
    New-Variable -Option Constant -Name 'fileNameToBeFound' -Value ([string]::Concat($ViewName,"View*"))
    
    if([System.IO.Directory]::Exists($viewSubfolderPath) -eq $false) {
        $viewPathsInParentFolder = Get-ViewFilesInFolder $viewSubfolderPath $fileNameToBeFound
    }
     
    [array]$viewPathsInSubfolder = Get-ViewFilesInFolder $viewSubfolderPath $fileNameToBeFound

    if($viewPathsInSubfolder.Count -gt 0) { #1 or more views were found, but we'll only return the first one in the array.
        return $viewPathsInSubfolder[0];
    }
    else { #view not found in subfolder, now about to look in parent folder $websitePath\Views\ non recursively
        $viewPathsInParentFolder = Get-ViewFilesInFolder "$websitePath\Views\" $fileNameToBeFound
               
        if($viewPathsInParentFolder.Count -gt 0) {
            return $viewPathsInParentFolder[0];
        }
    }
}

function Get-ViewFilesInFolder {
param(
    [string]$folderPath, 
    [string]$fileName
)
    return (
        (Get-ChildItem -Path $folderPath -Filter $fileName -ErrorAction SilentlyContinue -Force ) | 
		where-object { $_.Name -match '(\.html$|\.ps1$)' } | 
			Select-Object BaseName, Fullname, Name, Extension
    )
}

function Global:Get-View {
param(
    [string] $ViewName = $script:invokedActionName,
    [hashtable] $ViewData = $null,
	[string] $ControllerName = $script:invokedControllerName
) 

	DEBUG "Viewname: $viewName"
    DEBUG "ControllerName: $controllerName"
    DEBUG "ViewData: $ViewData"

    . $websitePath\core\ViewHelperFunctions.ps1;
    [array]$ViewFileInfoList = Find-View2 `
		-ViewName $ViewName `
		-Websitepath $websitePath `
		-ControllerName $ControllerName
    
    if (@($ViewFileInfoList).Count -eq 0) {
        return "No matching view called `'$ViewName`' found in folders \Views\$controllerName\ or \Views\"
    }
    else {
        
        if($viewData -ne $null) {
            foreach($item in $ViewData.getEnumerator()) {
                New-Variable -Name $item.Name -Value $item.Value
            }
        }
        
        if($ViewFileInfoList[0].Extension -eq ".html") {

          $ViewContent = [string]::Concat("@`"`n",(gc -Raw $ViewFileInfoList[0].Fullname),"`n`"@")
          return [scriptblock]::Create($ViewContent).Invoke()
        }
        else {
            return (. $ViewFileInfoList[0].Fullname )
        }
    }
}

Export-ModuleMember -Function 'Get-View'
