function Import-Controllers{
    return (ls $LeslieAppBasePath\Controllers -Filter *Controller.ps1 -ErrorAction SilentlyContinue -Force) | select BaseName,Fullname,Name
}

$ViewLoader = New-Object PSObject;
$ViewLoader | Add-Member -PassThru -MemberType ScriptMethod -name FindView -Value {
param(
    [string]$ViewName
)   
    $fileNameToBeFound = [string]::Concat($ViewName,"View*") 
    $viewPathsInSubfolder = (ls -Path "$LeslieAppBasePath\Views\$invokedControllerName" -Filter $fileNameToBeFound -ErrorAction SilentlyContinue -Force )| where-object { $_.Name -match '(\.html$|\.ps1$)' } |select BaseName,Fullname,Name,Extension

    if(@($viewPathsInSubfolder).Count -eq 1) { #i.e. only one view with the given name was found.
        return $viewPathsInSubfolder
    }
    if(@($viewPathsInSubfolder).Count -gt 1) { #i.e. more than one view with the given name was found.
        return $viewPathsInSubfolder[0] #we'll only return the first one.
    }
    if(@($viewPathsInSubfolder).Count -eq 0) { #view not found in subfolder, now about to look in parent folder $LeslieAppBasePath\Views\ non recursively
        $viewPathsInParentFolder = (ls -Path "$LeslieAppBasePath\Views\" -Filter $fileNameToBeFound -ErrorAction SilentlyContinue -Force ) | where-object { $_.Name -match '(\.html$|\.ps1$)' } | select BaseName,Fullname,Name,Extension
        
        if(@($viewPathsInParentFolder).Count -eq 1) {
            return $viewPathsInParentFolder[0]
        }
        
        if(@($viewPathsInParentFolder).Count -gt 1) {
            return $viewPathsInParentFolder[0]
        }
    }
}

$ViewLoader | Add-Member -PassThru -MemberType ScriptMethod -name GetView -Value {
param(
[string]$ViewName
)
    $ViewFileInfoList = $ViewLoader.FindView($ViewName) 
    return (. $ViewFileInfoList[0].Fullname)
}

function Get-View {
param(
    [string]$ViewName = $invokedActionName,
    [hashtable]$ViewData = $null
) 

    [array]$ViewFileInfoList = $ViewLoader.FindView($ViewName) 
    
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