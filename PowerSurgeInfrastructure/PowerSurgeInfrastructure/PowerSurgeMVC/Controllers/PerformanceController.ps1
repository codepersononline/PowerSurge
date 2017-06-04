#Used for Performance Testing Only!

$Controller = New-Module 'PerformanceController' {
Param()
  
    Function FastRequest {
		return '<!DOCTYPE html><html><head></head><body>FastRequest function called at' + [DateTime]::Now.ToString() + '</body></html>'
    }
	
	Function FastRequestWithCacheDelay {
		
		$global:Response.Cache.SetLastModified([DateTime]::Now.AddDays(-1))
        return '<!DOCTYPE html><html><head></head><body>FastRequest function called at' + [DateTime]::Now.ToString() + '</body></html>'
    }

    Function SlowRequest {
    param(
        [Parameter(Mandatory=$false)]
        [int] $delay
    ) 
		$result = 'SlowRequest called at' + [DateTime]::Now.ToString() + ".  Now delaying request for $delay seconds"
        Start-Sleep $delay
        return $result
    }
    Export-ModuleMember -Function ('FastRequest','SlowRequest')
} -AsCustomObject;