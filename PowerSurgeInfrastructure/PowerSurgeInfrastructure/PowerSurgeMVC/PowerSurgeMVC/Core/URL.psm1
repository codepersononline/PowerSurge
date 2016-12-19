# validURLChars is the list of allowable of characters in the URL... 
[regex]$script:validURLChars  = '^[//a-zA-Z0-9~%.:_\-]+$';

<#
.Synopsis
   Function is used to clean up the Requested URL string prior to routing.
.DESCRIPTION
   
.EXAMPLE
   Trim-FirstAndLastSlashesOnURL -rURL /sdfjiosdf/ will return string sdfjiosdf
#>
function Trim-FirstAndLastSlashesOnURL {
[cmdletbinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $rURL
)
    if($rURL.StartsWith('/') -eq $true) {
        $rURL = $rURL.Substring(1); #trim the first forward slash off the url string.
    }

    if($rURL.EndsWith('/') -eq $true){ 
        $rURL  = $rURL.TrimEnd('/');  #trim the last forward slash off the url string.
    }

    $rURL;
}

<#
.Synopsis
 This Function will take the given string and make sure that it contains no unacceptable characters. Returns true/false.
.DESCRIPTION
The given string is matched against the following regex: ^[//a-zA-Z0-9~%.:_\-]+$
.EXAMPLE
Validate-URL -inputURL '/yourweb-page'
#>
function Validate-URL {
param(
    [Parameter(Mandatory=$true)]
    [string]$inputURL = ''
)
  $inputURL -match $script:validURLChars
}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
#>
function Is-URLEmpty {
param([string]$URLParam)
    return ($URLParam -ne '/')
}