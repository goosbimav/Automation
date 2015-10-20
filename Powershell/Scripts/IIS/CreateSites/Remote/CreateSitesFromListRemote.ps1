############################################################################# 
## 
## Remote IIS Site Manipulation for Remote Servers   
## Version : 1.0 
##
## Author: Gus Sbirakis
## Last Modified: 01/09/2014
## Does IIS site manipulation for remote server(s)
##
## Prerequisite:
##	
## 	
##
############################################################################## 

$CurrentPath = Set-Location
$ServerListFileToUse = "ListOfServers-MASTER-iLand.txt"
$ServerListFilePath = $CurrentPath + "List_Of_Servers"
$ServerListFile = "$ServerListFilePath\$ServerListFileToUse"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
$MyDomain = "HBPNA"
$MyUserName = Read-Host "Enter User Name to use"
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$Credentials = Get-Credential $MyDomain\$MyUserName
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword
$MyDrive = "C$"
$RemotePath = "\\$ServerName\$MyDrive"
$SourcePath = $CurrentPath + "ToCopy"
$DestDir = "$RemotePath\Windows\System32\drivers\etc"

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




import-module WebAdministration
#Pipe in a list of sites from a text file
$Directory = "U:\TMP\E-stuff\Scripting\Powershell\Scripts\IIS\CreateSites\Remote\ListOfSites.txt"
$ListOfSites = Get-Content $Directory | Where {$_ -notmatch '^\s+$'}

#Adding a list of Site Binding
#$AddSites = Invoke-Command -ComputerName TMPTBWEB12P {foreach ($Site in $ListOfSites) {Import-Module WebAdministration; New-WebBinding -Name "SeoSiteCluster" -IPAddress "*" -Port 80 -HostHeader $Site}}
#$AddSites.value

#foreach ($Site in $ListOfSites) {
#Invoke-Command -ComputerName TMPTBWEB12P Import-Module WebAdministration; (New-WebBinding -Name "SeoSiteCluster" -IPAddress "*" -Port 80 -HostHeader $Site)
#}

$command = foreach ($Site in $ListOfSites) {New-WebBinding -Name "SeoSiteCluster" -IPAddress "*" -Port 80 -HostHeader $Site}
#Invoke-Command -ComputerName TMPTBWEB12P -ScriptBlock {$command}
#Invoke-Command -ComputerName TMPTBWEB12P -Script {$command}
Invoke-Command -FilePath U:\TMP\E-stuff\Scripting\Powershell\CreateSitesFromList.ps1 -ComputerName TMPTBWEB12P 


#Removing a list of Site Binding
#foreach ($Site in $ListOfSites) {
#Remove-WebBinding -Name "SeoSiteCluster" -Port 80 -IPAddress "*" -HostHeader $Site
#}

#Check to see if bindings are there
#Get-WebBinding -Name gustest2