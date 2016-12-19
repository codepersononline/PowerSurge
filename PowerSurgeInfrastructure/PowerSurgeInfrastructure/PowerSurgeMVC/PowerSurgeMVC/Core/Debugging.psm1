$script:debuggingMessages = @();
$currentTime = Get-Date;
function Script:Debug {
param(
	[string] $message
)
    if($AppConfig.debugging) {
        $script:debuggingMessages += $message;
    }
}
function Get-DebuggingPage {
	
	$dbgheader = '<div id="debugging">'+ 
		(CSS 'debugging.css') + 
		(Script 'jquery-1.11.1.min.js') + 
		(Script 'debugging.js');

	$dbgfooter = '</div>'
	
	[string] $finMessageStr = '';
	
	foreach( $message in $script:debuggingMessages) {
		$finMessageStr = [string]::Concat($finMessageStr, 
			'<p>', $message, '</p>');
	}
	$renderingTime = 'PowerSurge rendered in this page in: ' + (New-TimeSpan -Start $currentTime).TotalSeconds + ' Seconds'
	return $dbgheader + $finMessageStr + $renderingTime + $dbgfooter 
	
}
Export-ModuleMember -Variable * -Function *
