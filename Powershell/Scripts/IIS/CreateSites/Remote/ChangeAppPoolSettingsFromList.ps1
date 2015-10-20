############################################################################# 
## 
## Remote IIS Site Manipulation for Remote Servers   
## Version : 1.0 
##
## Last Modified: 04/21/2015
## Does IIS site manipulation for app pool settings for remote server(s)
##
## Prerequisite:
##	
## 	
##
############################################################################## 

#Global variables

$CurrentPath = Set-Location
#$ServerName = Read-Host "Please enter the destination Server"
$ServerListFileToUse = "List_Of_Servers_Test.txt"
$ServerListFilePath = $CurrentPath + "List_Of_Servers"
$ServerListFile = "$ServerListFilePath\$ServerListFileToUse"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
#$MyDomain = "HBPNA"
$MyDomain = Read-Host "Enter Domain to use"
$MyUserName = Read-Host "Enter User Name to use"
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
$MyDrive = "C$"
$RemotePath = "\\$ServerList\$MyDrive"


#Function that Temporarily maps to each remote server for authentication
Function Map-to-Server ($Server)
	{
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	
	#Remove any previously mapped shares
	net use $RemotePath /delete /y
	Write-Host
	Write-Host "Mapping to server:" $Server -Foreground Yellow		
	#net use $RemotePath -Credential $Credentials
	 		
	#Wait a few seconds before mapping again
	Write-Output " "
	Write-Output " "
	Write-Host "Waiting 2 sec " -foreground Yellow 
	Write-Output " "
	Write-Output " "
	#Start-Sleep -s 2
	
	net use $RemotePath /USER:$MyDomain\$MyUserName Widiliki28
	Write-Host "Mapped to Server..." -Foreground Yellow
	Write-Host
	}


Function Apply-IIS-Changes ($Server)
	{
	#Check to see if the App Pool exits.
	#if(Test-Path ("IIS:\AppPools\" + $AppPoolName))
	#	{
		$AppPoolName = Read-Host "Please enter the AppPool Name"
		$AppPoolRecycleTime = "4320"
		
		Write-Host
		Write-Host "Server List that is being used "$ServerListFile" " -foreground yellow
		Write-Host
		#Change the App Pool recycle time
		Import-Module WebAdministration
		$AppPoolName.recycling.periodicRestart.requests = "$AppPoolRecycleTime"
		$AppPoolName | Set-Item
	#	}
		
	}	


#Check to see if bindings are there
#Get-WebBinding -Name gustest2

ForEach($Server in $ServerList) 
	{
	Map-to-Server($Server)
	Apply-IIS-Changes($Server)
	}

#Remove any mapped shares 
net use $RemotePath /delete /y

PAUSE