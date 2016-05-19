# validURLChars is the list of allowable of characters in the URL... 
[regex]$private:validURLChars  = '^[a-z0-9~%.:_\-]+$';

function Trim-FirstAndLastSlashesOnURL {
param(
    [Parameter(Mandatory=$true)]
    [string]$rURL
)
    if($rURL.StartsWith('/') -eq $true) {
        $rURL = $rURL.Substring(1); #trim the first forward slash off the url string.
    }

    if($rURL.EndsWith('/') -eq $true){ 
        $rURL  = $rURL.TrimEnd('/'); 
    }
    return $rURL;
}

function Validate-URLSegments {
#function will take an array of strings and loop through each element to make sure that it contains no unacceptable characters.
#function will return the integer of which part has the broken character.
param(
    [Parameter(Mandatory=$true)]
    [string]$inputURL = ''
)
	[int]$URLSegmentWithErrors = 0;
	#TODO: loop through $IncomingURLParts and Call Validate-URLSegment for each element.
   
	<# Pseudo code:
	if( $URLSegmentWithErrors has errors) {
		throw "Your URL is fucked."
	}
	#>
	return ($inputURL -match $validURLChars)
}

function IsURLEmpty {
param([string]$URLParam)
    return ($URLParam -ne '/')
}