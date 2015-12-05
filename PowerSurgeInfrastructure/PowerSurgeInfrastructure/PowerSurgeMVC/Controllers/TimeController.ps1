$TimeController = New-Object –TypeName PSObject;

$TimeController | Add-Member -MemberType ScriptMethod -Name "Index" -Value { 
        
return @"
<html>
    <head></head>
    <body>
        <h1>Hello Internet World!</h1>
    </body>
</html>
"@
}

 $TimeController | Add-Member -MemberType ScriptMethod -Name "CurrentDateAndTime" -Value { 
         $Now = [datetime]::Now.ToString()   
         $Timezone = [TimeZone]::CurrentTimeZone.StandardName
         return "
         <html>
             <head></head>
             <body>
                 <h2>The current date and time is $now in $Timezone</h2>
            </body>
          </html>"
     }

$TimeController | Add-Member -MemberType ScriptMethod -Name "GetDateAndTime" -Value { 
    param($timezone = 0)
    
    try{$timezone = [convert]::ToInt32($timezone)}
    catch{return "<html><head></head><body><h2>$timezone couldn't be converted to an int</h2><body></html>"}
    
    if (($timezone -gt -12) -and ($timezone -lt 14)) {
        $Now = [datetime]::Now
        $newtime = $now.addHours($timezone)
        return "
        <html>
            <head></head>
            <body>
                <h2>The calculated date and time is $newtime with GMT offset of $timezone hours.</h2>
        </body>
        </html>"
    } else {  
         return   "<html>
                <head></head>
                <body>
                    <h2>Only values that represent UTC/GMT hour offsets are valid. The value given must be between -12 and +14</h2>
            </body>
            </html>"
    }
}

$TimeController | Add-Member -MemberType ScriptMethod -Name "AddTwoNumbers" -Value { 
    param(
        $firstNumber = 0, 
        $secondNumber = 0
    )
    
    try{$firstNumber = [convert]::ToInt32($firstNumber)
        $secondNumber = [convert]::ToInt32($secondNumber)
    }
    catch{return "<html><head></head><body><h2>One of the parameters couldn't be converted to an int</h2><body></html>"}
   
        return "
        <html>
            <head></head>
            <body>
                <h2>$($firstNumber + $secondNumber)</h2>
        </body>
        </html>"
}