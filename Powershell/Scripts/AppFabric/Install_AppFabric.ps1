# This script install AppFabric on Windows with selected options. 

# --------------------------------------------------------------------
# Checking Execution Policy
# --------------------------------------------------------------------
#$Policy = "Unrestricted"
$Policy = "RemoteSigned"
If ((get-ExecutionPolicy) -ne $Policy) {
  Write-Host "Script Execution is disabled. Enabling it now"
  Set-ExecutionPolicy $Policy -Force
  Write-Host "Please Re-Run this script in a new powershell environment"
  Exit
}
 
# --------------------------------------------------------------------
# Define the variables.
# --------------------------------------------------------------------
$CurrentPath = Set-Location
$ScriptsDirectory = "C:\Scripts\"
$SetupDirectory = "C:\Scripts\Setup\AppFabric\"
$AppFabric = "WindowsServerAppFabricSetup_x64.exe"

# --------------------------------------------------------------------
# Installing AppFabric
# --------------------------------------------------------------------
cd $SetupDirectory

#This will install AppFabric with selected options (*NOTE: double quotes are required around the commas
#& .\$AppFabric /install /i cachingservice,cacheclient,cacheadmin /l:c:\temp\setup.log
#& .\$AppFabric /i hostingservices","hostingadmin","cachingservice","cacheclient","cacheadmin

#Below options are our standard installation
& .\$AppFabric /i cachingservice","cacheclient","cacheadmin

#This removes AppFabric
#& .\$AppFabric /r 

#CD back into originating directory
Pop-Location




