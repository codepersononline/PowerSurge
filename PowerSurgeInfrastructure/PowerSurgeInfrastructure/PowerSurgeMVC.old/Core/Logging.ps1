$DebugPreference = "continue"
$script:securitylogPath = "$PowerSurgeAppPath\Logs\security.log";
$script:filename = $MyInvocation.MyCommand.Name;	# we need this otherwise it will log the string 'add-securitylog' as the current filename in the log.

function Add-SecurityLog {
param($message)
	[string]::Concat($filename,", RequestID: ",$items['RequestID'],", ",$message) | out-File -Append -FilePath $script:securitylogPath
}

#1. load the log4net assembly (only using the .net 2.0 version at the moment)
try
{
    Add-Type -Path "$PowerSurgeAppPath\Resources\dll\log4net.dll";
}
catch [System.IO.FileLoadException]
{
    $_ | fl -Force 
    #http://stackoverflow.com/questions/8268503/loadfromremotesources-error-using-assembly-loadfrom
}

#2. load in the app.config file.
$log4netAppConfigFile = New-Object System.IO.FileInfo "$PowerSurgeAppPath\core\Log4netConfig\app.config"

#3. make sure the file exists, and if it does use the log4net XML static Configuruator method to configure the logger.
if($log4netAppConfigFile.Exists) { 
    Add-SecurityLog "log4net app.config file has been found at $PowerSurgeAppPath\core\Log4NetConfig\app.config, and is now about to be initialised...."
    [log4net.Config.XMLConfigurator]::Configure($log4netAppConfigFile)
}
else{ 
    # Add-SecurityLog ("File: $PowerSurgeAppPath\core\Log4NetConfig\app.config could not be found. Log4Net initialisation to MSSQL will now abort.")
}

function Create-Log4NetLogger{
	param([string]$filename)

	#2. create a new logger.
	[log4net.ILog]$log = [log4net.LogManager]::GetLogger($filename)

	#5. now the fun stuff. 

	<#
	$log.Debug( ([string]::Concat($env:COMPUTERNAME, " - Hello There!")) );
	$log.Info( "Here's some info i've put together just for you" );
	$log.Warn( "yep, pretty sure something is wrong" );
	$log.Error( "ok yeah, now it's competely broken." );
	$log.Fatal( "time to start updating that resume..." );
	#>

	return $log;

}


