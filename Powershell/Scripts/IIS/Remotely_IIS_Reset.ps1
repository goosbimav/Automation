############################################################################# 
## 
## Remote IIS Reset Script   
## Version : 1.0 
##
## This script resets IIS on a remote server(s)
##
## Prerequisite:
##	
## 	
##
############################################################################## 

#Authentication related parameters:
#$MyDomain = Read-Host 'Please enter the DOMAIN you are trying to connect to'
$MyDomain = "NEWYORK"
$MyUserName = Read-Host "Enter User Name to use"
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$MyDomain\$MyUserName", $Mypassword
#$Credentials = Get-Credential $MyDomain\$MyUserName

#Server related parameters:
#$Server = Read-Host "Please enter the Server name for IIS RESET"
$CurrentPath = Set-Location
$ServerListFile = $CurrentPath + "ListOfServers.txt"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue
	
#Drive and folder related parameters:
$MyDrive = "C$"
$RemotePath = "\\$Server\$MyDrive"


#Function that map drive to server
Function Map-Drive($Server, $Domain, $UserName, $Password)
{
	#Drive and folder related parameters:
	$MyDrive = "C$"
	$RemotePath = "\\$Server\$MyDrive"

	#Connect to Server by mapping to network drive
	Write-Output " "
	Write-Output "----------------------------------------"
	net use $RemotePath /user:$MyDomain\$MyUserName
	Write-Output "----------------------------------------"
}

#Function that maps drive to server
Function Run-Psexec($Server, $Domain, $UserName, $Password)
{
	#---
	#To enable PowerShell Remoting, run the following command 
	#Enable-PSRemoting -Force
	#To enable using: psexec \\[computer name] -u [admin account name] -p [admin account password] -h -d powershell.exe "enable-psremoting -force"
	
	#This is equivalent to CD to directory
	Push-Location "D:\User Data\My Documents\T\Tools\PSTools"

	#Remotely run the a command with "psexec"
	cmdkey.exe /add:$MyDomain /user:$MyUserName /pass:$Mypassword
	#.\psexec \\$ServerList -s powershell.exe "Enable-PSSessionConfiguration -Force"
	.\psexec \\$Server -s powershell.exe "Enable-PSRemoting -Force"

	#This CD's back to the original location specified above in "$CurrentPath = Set-Location"
	Pop-Location
	#---
}

#Function that does an IIS reset on server
Function Reset-IIS($Server, $Domain, $UserName, $Password)
{

	Write-Output " "
	Write-Output "----------------------------------------"
	Write-Output " "
	Write-Host "Conducting an IIS RESET on:" -foreground Yellow $Server
	Write-Output " " 
	Write-Output "----------------------------------------"
	Write-Output " "

	#Conduct command on remote servers
	Invoke-Command -ComputerName $Server -scriptblock {iisreset} -credential $Credentials
	
}

ForEach($Server in $ServerList)
	{
	Map-Drive($Server)
	Run-Psexec($Server)
	Reset-IIS($Server)
	}
	
Write-Output " "
Write-Output " "
PAUSE