# This script install IIS 7 as a role on Windows 2008 with selected options. 

# --------------------------------------------------------------------
# Checking Execution Policy
# --------------------------------------------------------------------
#$Policy = "Unrestricted"
$Policy = "RemoteSigned"
If ((get-ExecutionPolicy) -ne $Policy) {
  Write-Host "Script Execution is disabled. Enabling it now"
  #Set-ExecutionPolicy RemoteSigned
  Set-ExecutionPolicy $Policy -Force
  Write-Host "Please Re-Run this script in a new powershell environment"
  Exit
}
 
# --------------------------------------------------------------------
# Define the variables.
# --------------------------------------------------------------------
$InetPubRoot = "C:\Inetpub"
$InetPubLog = "C:\Inetpub\Log"
$InetPubWWWRoot = "C:\Inetpub\WWWRoot"
$IISLogsDirectory = "S:\Logs"
$PXLogsDirectory = "S:\PxLogs"
$DeployDirectory = "S:\Deployments"
$ScriptsDirectory = "C:\Scripts\"
$SetupDirectory = "C:\Scripts\Setup\DotNet"
$DotNet4 = "dotNetFx40_Full_setup.exe"
$DotNet45 = "dotNetFx45_Full_setup.exe"
$DotNet452 = "dotNetFx452_Full_setup.exe"
 
# --------------------------------------------------------------------
# Loading Feature Installation Modules
# --------------------------------------------------------------------
Import-Module ServerManager 
 
# --------------------------------------------------------------------
# Installing IIS
# --------------------------------------------------------------------
Add-WindowsFeature -Name Web-Common-Http,Web-Asp-Net,Web-Net-Ext,Web-Http-Redirect,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Http-Logging,Web-Log-Libraries,Web-Http-Tracing,Web-Request-Monitor,Web-Basic-Auth,Web-Url-Auth,Web-Filtering,Web-Performance,Web-Mgmt-Console,Web-Scripting-Tools,Web-Mgmt-Service,RSAT-Web-Server,WAS #-IncludeAllSubFeature

#Optional Features
#Add-WindowsFeature Web-Windows-Auth,Web-Mgmt-Compat,
 
# --------------------------------------------------------------------
# Loading IIS Modules
# --------------------------------------------------------------------
Import-Module WebAdministration
 
# --------------------------------------------------------------------
# Creating IIS Folder Structure
# --------------------------------------------------------------------
New-Item -Path $InetPubRoot -type directory -Force -ErrorAction SilentlyContinue
New-Item -Path $InetPubLog -type directory -Force -ErrorAction SilentlyContinue
New-Item -Path $InetPubWWWRoot -type directory -Force -ErrorAction SilentlyContinue

# --------------------------------------------------------------------
# Creating APP Specific Folder Structure
# --------------------------------------------------------------------
#New-Item -Path $IISLogsDirectory -type directory -Force -ErrorAction SilentlyContinue
#New-Item -Path $PXLogsDirectory -type directory -Force -ErrorAction SilentlyContinue
#New-Item -Path $DeployDirectory -type directory -Force -ErrorAction SilentlyContinue

# --------------------------------------------------------------------
# Copying old WWW Root data to new folder
# --------------------------------------------------------------------
$InetPubOldLocation = @(get-website)[0].physicalPath.ToString()
$InetPubOldLocation =  $InetPubOldLocation.Replace("%SystemDrive%",$env:SystemDrive)
Copy-Item -Path $InetPubOldLocation -Destination $InetPubRoot -Force -Recurse
 
# --------------------------------------------------------------------
# Setting directory access
# --------------------------------------------------------------------
$Command = "icacls $InetPubWWWRoot /grant BUILTIN\IIS_IUSRS:(OI)(CI)(RX) BUILTIN\Users:(OI)(CI)(RX)"
cmd.exe /c $Command
$Command = "icacls $InetPubLog /grant ""NT SERVICE\TrustedInstaller"":(OI)(CI)(F)"
cmd.exe /c $Command
 
# --------------------------------------------------------------------
# Setting IIS Variables
# --------------------------------------------------------------------
#Changing Log Location
$Command = "%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/sites -siteDefaults.logfile.directory:$InetPubLog"
cmd.exe /c $Command
$Command = "%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/log -centralBinaryLogFile.directory:$InetPubLog"
cmd.exe /c $Command
$Command = "%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/log -centralW3CLogFile.directory:$InetPubLog"
cmd.exe /c $Command
 
#Changing the Default Website location
Set-ItemProperty 'IIS:\Sites\Default Web Site' -name physicalPath -value $InetPubWWWRoot
 
# --------------------------------------------------------------------
# Checking to prevent common errors
# --------------------------------------------------------------------
If (!(Test-Path "C:\inetpub\temp\apppools")) {
  New-Item -Path "C:\inetpub\temp\apppools" -type directory -Force -ErrorAction SilentlyContinue
}
 
# --------------------------------------------------------------------
# Deleting Old WWWRoot
# --------------------------------------------------------------------
Remove-Item $InetPubOldLocation -Recurse -Force
 
# --------------------------------------------------------------------
# Resetting IIS
# --------------------------------------------------------------------
$Command = "IISRESET"
Invoke-Expression -Command $Command

# --------------------------------------------------------------------
# Install .NET
# --------------------------------------------------------------------
#cd $SetupDirectory

#This will install .NET 4.0 Full
#& .\$DotNet4 /I /q

#This will install .NET 4.5 Full
#& .\$DotNet45 /I /q

#This will install .NET 4.5.2 Full
#& .\$DotNet452 /I /q

# --------------------------------------------------------------------
# Install Cygwin
# --------------------------------------------------------------------
#This will install Cygwin
<#
cd $ScriptsDirectory
	function Install-Cygwin {
		param ( $InstallCygDir="$env:Scripts\cygInstall" )
		if(!(Test-Path -Path $InstallCygDir -PathType Container))
		{
			$null = New-Item -Type Directory -Path $InstallCygDir -Force
		}
	$client = new-object System.Net.WebClient
	$client.DownloadFile("http://cygwin.com/setup.exe", "$InstallCygDir\setup.exe" )
	Start-Process -wait -FilePath "$InstallCygDir\setup.exe" -ArgumentList "-q -n -l $InstallCygDir -s http://mirror.nyi.net/cygwin/ -R c:\Cygwin"
	Start-Process -wait -FilePath "$InstallCygDir\setup.exe" -ArgumentList "-q -n -l $InstallCygDir -s http://mirror.nyi.net/cygwin/ -R c:\Cygwin -P openssh"
	}
#>	




