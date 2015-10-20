############################################################################# 
## 
## Remote Task Manager Deployment Script   
## Version : 1.0 
##
## This script will add to a user to the local Admin group (Function AddToGroup)
##
##
##############################################################################

#Authentication related parameters:
$MyDomain = "NEWYORK"
#$MyDomain = "HBPNA"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword

#Server related parameters:
#$ServerName = "HBBHPR01.web.hbpub.net"
#$ServerName = Read-Host "Please enter the Target Server name"
#$ServerListFile = "D:\E-stuff\Automation\Powershell\Scripts\Remote_Administration\ListOfServers.txt"
$ServerListFile = "D:\E-stuff\Automation\Powershell\Scripts\Remote_Administration\HBPNAListOfServers.txt"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
$Result = @()  

#Drive and folder related parameters:
$MyDrive = "C$"
$SourcePath = "D:\E-stuff\Automation\Powershell\Scripts\Remote_Administration"
$RemotePath = "\\$Server\$MyDrive"
$DestDir = "$RemotePath\Scripts"

#Function that Temporarily maps to each remote server for authentication
Function Map-to-Server ($Server)
	{
	
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	
	#Remove any previously mapped shares 
	net use $RemotePath /delete /y
	
	#Wait a few seconds before mapping again
	Write-Output " "
	Write-Output " "
	Write-Host "Waiting 2 sec for "$MyServer" " -foreground yellow 
	Write-Output " "
	Write-Output " "
	Start-Sleep -s 2
	
	Write-Host
	Write-Host "Mapping to server:" $Server -Foreground Yellow		
	net use $RemotePath /user:$MyUserName #Enter password here
	Write-Host "Mapped to Server..." -Foreground White
	Write-Host
	}


Function AddToGroup($Server)
	{
	
	#User and Domain related parameters:
	##$Domain = "web.hbpub.net"
	$Domain = "HBPNA"
	#$Domain = "NEWYORK.com"
	#$DomainUsertoAdd1 = "svc_tasksched"
	$DomainUsertoAdd1 = "svc_mhewmi"
	
	#Wait a few seconds before mapping again
	Write-Output " "
	Write-Output " "
	Write-Host "Adding user:" $DomainUsertoAdd1 "to - Administrators Group" -foreground yellow 
	Write-Output " "
	Write-Output " "
	Start-Sleep -s 2
	
	$Group = [ADSI]"WinNT://$Server/Administrators"
	$Group.Add("WinNT://$Domain/$DomainUsertoAdd1")
	
	Write-Output " "
	Write-Output " "
	Write-Host "user" $DomainUsertoAdd1 "has been added to Group" -foreground white
	Write-Output " "
	Write-Output " "
	Start-Sleep -s 2
	
	
	#Wait a few seconds before mapping again
#	Write-Output " "
#	Write-Output " "
#	Write-Host "Adding user:" $DomainUsertoAdd1 "to - Distributed COM Users Group" -foreground yellow 
#	Write-Output " "
#	Write-Output " "
#	Start-Sleep -s 2
	
#	$Group = [ADSI]"WinNT://$Server/Distributed COM Users"
#	$Group.Add("WinNT://$Domain/$DomainUsertoAdd1")
	
#	Write-Output " "
#	Write-Output " "
#	Write-Host "user" $DomainUsertoAdd1 "has been added to Group" -foreground white
#	Write-Output " "
#	Write-Output " "
#	Start-Sleep -s 2
	
	}
	
	ForEach($Server in $ServerList) 
	{
	Map-to-Server ($Server)
	AddToGroup($Server)
	}
	
#Remove any mapped shares 
net use $RemotePath /delete /y
	
PAUSE