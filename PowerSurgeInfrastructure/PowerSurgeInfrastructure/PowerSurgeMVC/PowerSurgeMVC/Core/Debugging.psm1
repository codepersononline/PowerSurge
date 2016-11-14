$script:debuggingMessages = @();

function Script:Debug {
param(
	[string] $message
)
    if($AppConfig.debugging) {
        $script:debuggingMessages += $message;
    }
}
function Get-DebuggingPage {
	$dbgheader = '<div id="debugging">'+ (CSS 'debugging.css');
	$dbgfooter = '</div>'
	
	[string] $finMessageStr = '';
	
	foreach( $message in $script:debuggingMessages) {
		$finMessageStr = [string]::Concat($finMessageStr, 
			'<p>', $message, '</p>');
	}

	return $dbgheader + $finMessageStr + $dbgfooter;
	
}
Export-ModuleMember -Variable * -Function *
