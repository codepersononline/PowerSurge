function Test-PowerSurgeConcurrency {
    Start-RSJob -ScriptBlock {
        Invoke-WebRequest 'http://localhost:60453/Performance/SlowRequest/02'
}

$null = 1..10 |
        Start-RSJob -Throttle 10 -ScriptBlock {
            Invoke-WebRequest 'http://localhost:60453/Performance/FastRequest'
        }
        
    Get-RSJob | 
        Wait-RSJob | 
        Receive-RSJob       
}
#use this to test overall throughput

Measure-Command {
    Test-PowerSurgeConcurrency 
}


Test-PowerSurgeConcurrency | select Content
Get-RSJob | Remove-RSJob
