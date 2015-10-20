#Authentication related parameters:
##$MyDomain = "NEWYORK"
$MyDomain = "HBPNA"
$MyUserName = Read-Host 'Please enter the user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword

$Result = @()  

function Hotfixreport 
{ 
	$computers = Get-Content D:\E-stuff\Automation\Powershell\Scripts\PatchLevel\ListOfServers.txt   
	$ErrorActionPreference = 'Stop'   
	#Function that Temporarily maps to each remote server for authentication
} 



Function Map-to-Server ($computer)
	{
	
	#Drive and folder related parameters:
	$RemotePath = "\\$computer\$MyDrive"
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
	Write-Host "Mapping to server:" $computer -Foreground Yellow		
	net use $RemotePath /user:$MyUserName #Enter password here
	Write-Host "Mapped to Server..." -Foreground White
	Write-Host
	}


ForEach ($computer in $computers) {  
 
  try  
    { 
	Map-to-Server ($computer)	
	
	#Get-HotFix -cn $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn | FT -AutoSize
	Get-HotFix -cn $computer | Select-Object HotFixID | FT -AutoSize 
	
	#To run this on a server individually from the command line
	#Get-HotFix -cn localhost | Select-Object HotFixID | FT -AutoSize > Hotfixreport.csv
	
	Hotfixreport > "$env:USERPROFILE\Desktop\Hotfixreport.txt"
	#Hotfixreport > "D:\E-stuff\Automation\Powershell\Scripts\PatchLevel\Hotfixreport.txt"
	 
    } 
 

 
catch  
 
    { 
	Write-Warning "System Not reachable:$computer" 
    }  
} 
 

