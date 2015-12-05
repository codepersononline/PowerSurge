$DebugPreference = "continue"
#1. load the log4net assembly (only using the .net 2.0 version at the moment)
try
{
    Add-Type -Path "$PSScriptRoot\log4net.dll"
}
catch [System.IO.FileLoadException]
{
    $_ | fl -Force 
    #http://stackoverflow.com/questions/8268503/loadfromremotesources-error-using-assembly-loadfrom
}


#3. load in the app.config file.
$CurrentScriptFolderPath = Split-Path $SCRIPT:MyInvocation.MyCommand.Path -Parent
$log4netAppConfigFile = New-Object System.IO.FileInfo "$CurrentScriptFolderPath\app.config"

#4. make sure the file exists, and if it does use the log4net XML static Configuruator method to configure the logger.
if($log4netAppConfigFile.Exists) { 
    Write-Debug "$CurrentScriptFilename : log4net app.config file has been found at $CurrentScriptFolderPath\app.config, and is now about to be initialised...."
   # [log4net.Config.XMLConfigurator]::Configure($log4netAppConfigFile)
    [log4net.Config.BasicConfigurator]::Configure()
}
else{ 
    Write-Error "File: $ScriptFolderPath\app.config could not be found. Logging initialisation will now abort." 
}
#2. create a new logger.
$CurrentScriptFilename = split-path $SCRIPT:MyInvocation.MyCommand.Path -Leaf
[log4net.ILog]$script:log = [log4net.LogManager]::GetLogger($CurrentScriptFilename)
[log4net.ILog]$script:log2 = [log4net.LogManager]::GetLogger("logger2")
#5. now the fun stuff. 
$log.Debug( "Hello World!" );
$log.Debug( ([string]::Concat($env:COMPUTERNAME, " - Hello There!")) );
$log.Info( "Here's some info i've put together just for you" );
$log.Warn( "yep, pretty sure something is wrong" );
$log.Error( "ok yeah, now it's competely broken." );
$log.Fatal( "time to start updating that resume..." );
$log2.Fatal("yeaahhhhhhhbitches")

