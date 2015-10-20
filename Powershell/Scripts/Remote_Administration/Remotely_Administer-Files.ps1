############################################################################# 
## 
## Remote File and Folder Manipulation Script   
## Version : 1.0 
##
## This script does file and folder manipulation on a remote server(s)
##
## Prerequisite:
##	
## 	
##
############################################################################## 

#Authentication related parameters:
$MyDomain = "NEWYORK"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword
#$Cred = Get-Credential $MyDomain\$MyUserName

#Server related parameters:
#$Server = Read-Host "Please enter the destination Server"
$CurrentPath = Set-Location
$ServerListFile = $CurrentPath + "ListOfServers.txt"
#$ServerListFile = "D:\E-stuff\Automation\Powershell\Scripts\Remote_Administration\ListOfServers.txt"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue

#Drive and folder related parameters:
$MyDrive = "C$"
$RemotePath = "\\$Server\$MyDrive"
$CurrentPath = Set-Location
$SourcePath = $CurrentPath + "TestCopyOrigin"
$DestDir = "$RemotePath\Test"

#Connect to Server by mapping to network drive
#net use $RemotePath /user:$MyDomain\$MyUserName
#net use $RemotePath $Mypassword /user:$MyDomain\$MyUserName
#net use $RemotePath /user:$MyUserName


#Function that creates a folder on a remote server
Function Create-Folder($Server)
{
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	$DestDir = "$RemotePath\Test"
	
	#Check to see if folder path currently exists
	Write-Host
	Write-Host "Checking for Folder path on:" $RemotePath -Foreground Blue
	Write-Host "..."
	
	if (!(Test-Path $DestDir))
	{
	#Create a Script Directory if it does not exist already
	Write-Host
	Write-Host "Remote Path not found." -Foreground Yellow
	Write-Host
	Write-Host "Creating directory:" $DestDir -Foreground White
	Write-Host 
	Write-Host "..."
	
	#Check if the directory exists. If if doesn't create it
	mkdir $DestDir
	}
	else
	{
	Write-Host
	Write-Host "Directory already exists:" -Foreground Red
	Write-Host
	Write-Host "Copying Script over to:" $DestDir -Foreground Yellow
	Write-Host 
	Write-Host "..."
	}
	
	#Copy all files with .ps1 extensions to destination directory
	Copy-Item $SourcePath\*.ps1 -Destination $DestDir -Recurse
}

	
Function Remove-Folder($Server)
{
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	$DestDir = "$RemotePath\Test"
	
	#Check to see if folder path currently exists
	Write-Host
	Write-Host "Checking for Folder path on:" $RemotePath -Foreground Blue
	Write-Host "..."
	
	if (!(Test-Path $DestDir))
	{
	#Create a Script Directory if it does not exist already
	Write-Host
	Write-Host "Remote Path not found." -Foreground Yellow
	Write-Host
	Write-Host "Nothing to do!" -Foreground White
	Write-Host 
	Write-Host "..."
	}
	else
	{
	Write-Host
	Write-Host "Directory exists:" -Foreground Red
	Write-Host
	Write-Host "Removing directory:" $DestDir -Foreground Yellow
	Write-Host 
	Write-Host "..."
	
	#Remove entire directory
	Remove-Item -Recurse -Force $DestDir
	
	#Remove all items within folder with or without exclusions 
	#Remove-Item c:\scripts\* -recurse
	#Remove-Item c:\scripts\* -exclude *.conf
	}
}

Function Rename-Folder($Server)
{
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	$DestDir = "$RemotePath\Test"
	$RenameTo = "TestRename"
		
	#Check to see if folder path currently exists
	Write-Host
	Write-Host "Checking for Folder path on:" $RemotePath -Foreground Blue
	Write-Host "..."
	
	if (!(Test-Path $DestDir))
	{
	#Create a Script Directory if it does not exist already
	Write-Host
	Write-Host "Remote Path not found." -Foreground Yellow
	Write-Host
	Write-Host "Nothing to do!" -Foreground White
	Write-Host 
	Write-Host "..."
	}
	else
	{
	Write-Host
	Write-Host "Directory exists:" -Foreground Red
	Write-Host
	Write-Host "Renaming directory:" $DestDir to $RenameTo -Foreground Yellow
	Write-Host 
	Write-Host "..."
	#Rename entire directory
	Rename-Item $DestDir $RenameTo
	
	#Rename File
	#Rename-Item $DestDir\Remotely_Copy-Files_ToServer.ps1 test.ps1  	
	}
}

Function Move-Folder($Server)
{
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	$DestDir = "$RemotePath\Test"
	$MoveToDir = "$RemotePath\MoveTest"
		
	#Check to see if folder path currently exists
	Write-Host
	Write-Host "Checking for Folder path on:" $RemotePath -Foreground Blue
	Write-Host "..."
	
	if (!(Test-Path $DestDir))
	{
	#Create a Script Directory if it does not exist already
	Write-Host
	Write-Host "Remote Path not found." -Foreground Yellow
	Write-Host
	Write-Host "Nothing to do!" -Foreground White
	Write-Host 
	Write-Host "..."
	}
	else
	{
	Write-Host
	Write-Host "Directory exists:" -Foreground Red
	Write-Host
	Write-Host "Moving directory:" $DestDir "to" $MoveToDir -Foreground Yellow
	Write-Host 
	Write-Host "..."
	#Move entire directory to new destination directory
	Move-Item $DestDir $MoveToDir
	}
}
	
#*****************************************************************************************
#This uses WinRM
#Invoke-Command -ComputerName $Server { Stop-Service W3SVC } -credential $Credentials
#To enable PowerShell Remoting, run the following command 
#Enable-PSRemoting -Force
#*****************************************************************************************

#Providing some time to ctrl-Z in case of error
Write-Output " "
Write-Output " "
Write-Output " "
Write-Host "Waiting 05 sec before executing...Please press (Ctrl+Z) to abort:" -foreground yellow 
Write-Output " "
Write-Output " "

Start-Sleep -s 05

Write-Output "----------"
Write-Output " "
Write-Host "Do something here :" -foreground green
Write-Output " "
Write-Output "----------"
Write-Output " "

#Execute Functions to perform
ForEach($Server in $ServerList)
	{
	#Create-Folder($Server)
	#Remove-Folder($Server)
	#Rename-Folder($Server)
	#Move-Folder($Server)
	}

	
Write-Output " "
Write-Output " "
PAUSE