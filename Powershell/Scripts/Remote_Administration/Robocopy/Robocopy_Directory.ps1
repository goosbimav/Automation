############################################################################# 
## 
## Remote Copy Logs from a remote Server(s) to a file share path   
## Version : 1.0 
##
## This script copies logs from a remote Server(s) to a file share path
##
## Prerequisite:
##	
## 	
##
############################################################################## 

$CurrentPath = Set-Location
#$ServerListFilePath = $CurrentPath + "List_Of_Servers"
#$ServerListFile = "$ServerListFilePath\$ServerListFileToUse"
#$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
$ServerName = Read-Host 'Please enter the server name to copy logs from'
$MyDomain = "HBPNA"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$Credentials = Get-Credential $MyDomain\$MyUserName
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword
$MyDrive = "S$"
$SourceIISLogs = "\\$ServerName\$MyDrive\Logs"
$SourcePXLogs = "\\$ServerName\$MyDrive\PxLogs"
$FileShare = "\\192.168.78.119\logs\$ServerName\"


#Function that Temporarily maps to each remote server for authentication
Function Map-to-Server ($ServerName)
	{
	
	#Drive and folder related parameters:
	$RemotePath = "\\$ServerName\$MyDrive"
	$MyDrive = "C$"
	
	Write-Host
	Write-Host "Removing previous Server Mappings from:" $ServerName -Foreground Yellow
	Write-Host 	
	#net use $RemotePath -Credential $Credentials
	#Remove any previously mapped shares 
	net use $RemotePath /delete /y
	
	#Wait a few seconds before mapping again
	Write-Host
	Write-Host "Pausing 2 sec for: "$ServerName" " -foreground yellow 
	Write-Host
	Start-Sleep -s 2
	
	Write-Host
	Write-Host "Mapping to server:" $ServerName -Foreground Yellow
	Write-Host
	net use $RemotePath /USER:$MyDomain\$MyUserName Nanabomb28
	Write-Host "Mapped to Server..." -Foreground White
	Write-Host
	
	#Set Remote Execution Policy
	Write-Host
	Write-Host "Enabeling Remote Execution for Powershell..." -Foreground White
	Write-Host
	powershell Enable-PSRemoting -Force
	
	}

#Function that Copys IIS Logs
Function RoboCopy-IIS-logs($ServerName)
	{
	
	#Drive and folder related parameters:
	$MyDrive = "S$"
	$SourceIISLogs = "\\$ServerName\$MyDrive\Logs"
	$FileShare = "\\192.168.78.119\logs\$ServerName\"
	
	if (!(Test-Path $FileShare))
	{
	#Create a Script Directory if it does not exist already
	Write-Host
	Write-Host "Attempting ROBOCOPY of Log Files..." -Foreground Yellow
	Write-Host "Remote FILE SHARE not found!" -Foreground Red
	Write-Host 
	Write-Host "..."
	}
	else
	{
	Write-Host
	Write-Host "Directory DOES exist!" -Foreground White
	Write-Host "Attempting ROBOCOPY of Log Files." -Foreground Yellow
	Write-Host "Copying Logs over to" $FileShare -Foreground White
	Write-Host 
	Write-Host "..."
	
	#copy contents while preserving svn hidden file attributes
	robocopy $SourceIISLogs $FileShare /E /COPYALL /LOG:Logs/Copy.log
	
	#Copy all files with .ps1 extensions to destination directory
	#Copy-Item $SourcePath\*.ps1 -Destination $DestDir -Recurse
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse -Credential $Credentials
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse

	}
}

#Function that Copys IIS Logs
Function RoboCopy-PX-logs($ServerName)
	{
	
	#Drive and folder related parameters:
	$MyDrive = "S$"
	$SourcePXLogs = "\\$ServerName\$MyDrive\PxLogs"
	$FileShare = "\\192.168.78.119\logs\$ServerName\"
	
	if (!(Test-Path $FileShare))
	{
	#Create a Script Directory if it does not exist already
	Write-Host
	Write-Host "Attempting ROBOCOPY of Log Files..." -Foreground Yellow
	Write-Host "Remote FILE SHARE not found!" -Foreground Red
	Write-Host 
	Write-Host "..."
	}
	else
	{
	Write-Host
	Write-Host "Directory DOES exist!" -Foreground White
	Write-Host "Attempting ROBOCOPY of Log Files..." -Foreground Yellow
	Write-Host "Copying Logs over to" $FileShare -Foreground White
	Write-Host 
	Write-Host "..."
	
	#Mirrors files and directories Source to Destination
	#robocopy $SourcePXLogs $FileShare /E /COPYALL /LOG:Logs/Copy.log
	robocopy $SourcePXLogs $FileShare /MIR /LOG:Logs/Copy.log
	
	#Copy all files with .ps1 extensions to destination directory
	#Copy-Item $SourcePath\*.ps1 -Destination $DestDir -Recurse
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse -Credential $Credentials
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse

	}
}


#ForEach($Server in $ServerList) 
#	{
	Map-to-Server($ServerName)
	RoboCopy-IIS-logs($ServerName)
	#RoboCopy-PX-logs($ServerName)
#	}
	
#Remove any mapped shares 
net use $RemotePath /delete /y

PAUSE