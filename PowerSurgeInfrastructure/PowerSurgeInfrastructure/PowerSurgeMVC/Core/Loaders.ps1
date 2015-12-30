function Load-Controllers {
    return (Get-ChildItem $LeslieAppBasePath\Controllers -Filter *Controller.ps1 -ErrorAction SilentlyContinue -Force) | select BaseName,Fullname,Name
}

function Find-View {
param(
    [string]$ViewName
)   
    New-Variable -Option Constant -Name 'viewFolderPath' -Value ([string]"$LeslieAppBasePath\Views\")
    New-Variable -Option Constant -Name 'viewSubfolderPath' -Value ([string]"$viewFolderPath\$invokedControllerName")
    New-Variable -Option Constant -Name 'fileNameToBeFound' -Value ([string]::Concat($ViewName,"View*"))
    
    if([System.IO.Directory]::Exists($viewSubfolderPath) -eq $false) {
        $viewPathsInParentFolder = Get-ViewFilesInFolder $viewSubfolderPath $fileNameToBeFound
    }
     
    [array]$viewPathsInSubfolder = Get-ViewFilesInFolder $viewSubfolderPath $fileNameToBeFound

    if($viewPathsInSubfolder.Count -gt 0) { #1 or more views were found, but we'll only return the first one in the array.
        return $viewPathsInSubfolder[0];
    }
    else { #view not found in subfolder, now about to look in parent folder $LeslieAppBasePath\Views\ non recursively
        $viewPathsInParentFolder = Get-ViewFilesInFolder "$LeslieAppBasePath\Views\" $fileNameToBeFound
               
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
        select BaseName, Fullname, Name, Extension
    )
}

function Get-View {
param(
    [string]$ViewName = $invokedActionName,
    [hashtable]$ViewData = $null
) 

    [array]$ViewFileInfoList = Find-View $ViewName 
    
    if (@($ViewFileInfoList).Count -eq 0) {
        return "No matching view called `'$ViewName`' found in folders \Views\$invokedControllerName\ or \Views\"
    }
    else {
        
        if($viewData -ne $null) {
            foreach($item in $ViewData.getenumerator()) {
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

#Export-ModuleMember -Function 'Get-View'
#Export-ModuleMember -Function 'Load-Controllers'
