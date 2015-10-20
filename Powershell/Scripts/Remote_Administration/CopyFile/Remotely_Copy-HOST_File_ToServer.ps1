############################################################################# 
## 
## Remote Copy Host File to Multiple Servers   
## Version : 1.0 
##
## This script does file and folder manipulation on a remote server(s)
##
## Prerequisite:
##	
## 	
##
############################################################################## 

#Global variables

$CurrentPath = Set-Location
#$ServerName = Read-Host "Please enter the destination Server"
#$ServerListFileToUse = "ListOfServers-PXWebServers-iLand.txt"
#$ServerListFileToUse = "ListOfServers-Brainhoney-iLand.txt"
#$ServerListFileToUse = "ListOfServers-MarsServers-iLand.txt"
#$ServerListFileToUse = "ListOfServers-SVCServers-iLand.txt"
#$ServerListFileToUse = "ListOfServers-DLAPServers-iLand.txt"
#$ServerListFileToUse = "ListOfServers-AppFabricServers-iLand.txt"
#$ServerListFileToUse = "ListOfServers-EnterpriseServers-iLand.txt"
#$ServerListFileToUse = "ListOfServers-Test-Server.txt"
$ServerListFileToUse = "ListOfServers-MASTER-iLand.txt"
$ServerListFilePath = $CurrentPath + "List_Of_Servers"
$ServerListFile = "$ServerListFilePath\$ServerListFileToUse"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
#$MyDomain = "HBPNA"
$MyDomain = Read-Host "Enter Domain to use"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$Credentials = Get-Credential $MyDomain\$MyUserName
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword
$MyDrive = "C$"
$RemotePath = "\\$ServerName\$MyDrive"
$SourcePath = $CurrentPath + "ToCopy"
$DestDir = "$RemotePath\Windows\System32\drivers\etc"
$GitDir = "D:\GitHub\sysops-hosts"


Function Git-Pull ($GitDir)
{

	$GitUrl = Read-Host "Enter GIT URL to use"		
	
		if (Test-Path $GitDir)
		{
		#CD to git file source location
		Push-Location $GitDir
	
		#grab the latest file from the git repo
		#Write-Host "Git URL to use: " $giturl
		git pull $giturl
		
		#This CD's back to original location 
		Pop-Location
		}
}

Function Git-Push ($GitDir)
{

	$GitUrl = Read-Host "Enter GIT URL to use"	
	
		if (Test-Path $GitDir)
		{
		#CD to git file source location
		Push-Location $GitDir
		
		#add all new or modified files
		git add .
		
		#NOTE: Make sure to add the message between single quotes
		$gitMessage = Read-Host "Enter GIT commit message"
		git commit -m $gitMessage
		
		#Push the latest git files up to git repo
		git push $giturl
		
		#This CD's back to original location 
		Pop-Location
		}
}

Function Rename-file ($GitDir)
{
		if (Test-Path $GitDir)
		{
		#CD to git file source location
		Push-Location $GitDir

		#Rename host file
		$CopyFromPath = "D:\E-stuff\Automation\Powershell\Scripts\Remote_Administration\CopyFile\ToCopy"

		Write-Host "Current directory is " $CopyFromPath -Foreground Yellow
		#Make a copy of the hosts files pulled down from Git
		#Copy-Item hosts.iQA hosts
		Copy-Item hosts.iland hosts
		Copy-Item -Path $GitDir\hosts -Destination $CopyFromPath\hosts
		
		#This CD's back to original location 
		Pop-Location
		}
}

Function CleanUp ($GitDir)
{
		if (Test-Path $GitDir)
		{
		#$gitusername = Read-Host "Enter GIT user name"
		#$gitpassword = Read-Host 'Enter GIT password' -AsSecureString
		
		#CD to git file source location
		Push-Location $GitDir
	
		#Delete extra host file that was copied earlier so as to not accidental push file back up to Git repo
		Remove-Item hosts
		
		#This CD's back to original location 
		Pop-Location
		}
}	

#Function that Temporarily maps to each remote server for authentication
Function Map-to-Server ($Server)
	{
	
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	
	Write-Host
	Write-Host "Mapping to server:" $Server -Foreground Yellow		
	#net use $RemotePath -Credential $Credentials
	#Remove any previously mapped shares 
	net use $RemotePath /delete /y
	
	#Wait a few seconds before mapping again
	Write-Output " "
	Write-Output " "
	Write-Host "Waiting 2 sec for "$MyServer" " -foreground yellow 
	Write-Output " "
	Write-Output " "
	Start-Sleep -s 2
	
	net use $RemotePath /USER:$MyDomain\$MyUserName Nanabomb28
	Write-Host "Mapped to Server..." -Foreground White
	Write-Host
	}

#Function that creates a script folder on a remote server
Function Copy-File($Server)
	{
	
	#Drive and folder related parameters:
	$SourcePath = $CurrentPath + "ToCopy"
	$MyDrive = "C$"
	$RemotePath = "\\$Server\$MyDrive"
	$DestDir = "$RemotePath\Windows\System32\drivers\etc"
	
	if (!(Test-Path $DestDir))
	{
	#Create a Script Directory if it does not exist already
	Write-Host
	Write-Host "Remote Path not found." -Foreground Yellow
	Write-Host 
	Write-Host "..."
	}
	else
	{
	
		#Check to see if there a backup of the current "Hosts" File  
		if (!(Test-Path $DestDir\hosts.backup))
		{
		#If there isn't a backup create one
		Write-Host
		Write-Host "Backing up current hosts file." -Foreground Yellow
		Write-Host 
		Write-Host "..."
		#Backup current Hosts file
		Copy-Item $DestDir\hosts $DestDir\hosts.backup
		}
		else
		{
		#If backup already exists do nothing
		Write-Host
		Write-Host "Backup file already exists:" -Foreground Red
		Write-Host "No need to create backup file..." -Foreground Red
		Write-Host 
		Write-Host "..."
		}
	
	Write-Host
	Write-Host "Directory exists:" -Foreground Red
	Write-Host
	Write-Host "Copying the HOST file over to:" $DestDir -Foreground Yellow
	Write-Host 
	Write-Host "..."
	
	#Copy all files with .ps1 extensions to destination directory
	#Copy-Item $SourcePath\*.ps1 -Destination $DestDir -Recurse
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse
	#Copy-Item $SourcePath\* -Destination $DestDir -Recurse -Credential $Credentials
	Copy-Item $SourcePath\* -Destination $DestDir -Recurse

	}
}

#Invoke-Command -ComputerName $MyServer { Stop-Service W3SVC } -credential $Credentials

#Ping server to assure that it it being rebooted
#test-connection -Computername $ServerName -BufferSize 16 -Count 10

Rename-file ($GitDir)
#Git-Pull ($GitDir)
Git-Push ($GitDir)


ForEach($Server in $ServerList) 
	{
	Map-to-Server($Server)
	Copy-File($Server)
	}

CleanUp ($GitDir)
	
#Remove any mapped shares 
net use $RemotePath /delete /y

PAUSE