#Used for Performance Testing Only!

$PerformanceController = New-Controller 'PerformanceController' {
param()
  
    function FastRequest {
        return 'FastRequest function called at' + [DateTime]::Now.ToString();
    }

    function SlowRequest {
    param(
        [Parameter(Mandatory=$false)]
        [int] $delay
    ) 
		$result = 'SlowRequest called at' + [DateTime]::Now.ToString() + ".  Now delaying request for $delay seconds"
        Start-Sleep $delay
        return $result
    }
    Export-ModuleMember -Function ('FastRequest','SlowRequest')
} -AsCustomObject