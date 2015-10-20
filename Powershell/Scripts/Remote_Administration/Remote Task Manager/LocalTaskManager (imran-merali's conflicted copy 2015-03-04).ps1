############################################################################# 
## 
## Remote Task Manager Deployment Script   
## Version : 1.0 
##
## This script will Deploy a scheduled task with all configured parameters 
##
## Prerequisite:
##	User service must be add to the local Admin group (Function AddToGroup) 
## 	A folder named Scripts but be present on the root with the relevant script
##
############################################################################## 


#Authentication related parameters:
##$MyDomain = "NEWYORK"
$MyDomain = "HBPNA"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword

#Server related parameters:
#$ServerName = "HBBHPR01.web.hbpub.net"
#ServerName = Read-Host "Please enter the Target Server name"
$ServerListFile = "C:\Prelaunch\ListOfServers-MarsServers-PROD.txt"
##$ServerListFile = "D:\E-stuff\Automation\Powershell\Scripts\Delete_Old_Logs\ListOfServers.txt"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
$Result = @()  

#Drive and folder related parameters:
$MyDrive = "C$"
$SourcePath = "C:\Prelaunch"
$RemotePath = "\\$Server\$MyDrive"
$DestDir = "$RemotePath\Scripts"

#**************************************************************************************************	

#Function that Temporarily maps to each remote server for authentication
Function Map-to-Server ($Server)
	{
	
	#Drive and folder related parameters:
	$MyDrive = "C$"
	$RemotePath = "\\$Server\$MyDrive"

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
	net use $RemotePath /user:$MyUserName
	Write-Host "Mapped to Server..." -Foreground White
	Write-Host
	}

#Function that creates a script folder on a remote server
Function AddToGroup($Server)
	{
	
	#User and Domain related parameters:
	##$Domain = "web.hbpub.net"
	$Domain = "hbpna.com"
	$DomainUsertoAdd1 = "svc_tasksched"
		
	$Group = [ADSI]"WinNT://$Server/Administrators"
	$Group.Add("WinNT://$Domain/$DomainUsertoAdd1")
	}
	
#Function that creates a script folder on a remote server
Function Create-Folder($Server)
	{
	
	#Drive and folder related parameters:
	$RemotePath = "\\$Server\$MyDrive"
	$MyDrive = "C$"
	$DestDir = "$RemotePath\Scripts"
	
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
	
	Copy-Item $SourcePath\*.ps1 -Destination $DestDir -Recurse
}

# EXAMPLE:	Create-Folder ServerName 
#Create-Folder $ServerName 

#Function that queries scheduled task on a remote server
Function Get-ScheduledTask ($Server)
	{
	Write-Host "Computer: $Server"
	$Command = "schtasks.exe /query /s $Server"
	Invoke-Expression $Command
	Clear-Variable Command -ErrorAction SilentlyContinue
	Write-Host "`n"
	}

# EXAMPLE: Get-ScheduledTask -ComputerName $ServerName	
	
#Function that create a scheduled task on a remote server	
Function Create-ScheduledTask($Server) 
	{
		#Task Related parameters:
		$TaskName = "DELETE_OLD_LOGS"
		$TaskRun = '"Powershell.exe -ExecutionPolicy Unrestricted c:\Scripts\DeleteOLDlogs.ps1"'
		##$RunAsUser = "svc_tasksched@web.hbpub.net"
		$RunAsUser = "svc_tasksched@hbpna.com"
		$RunAsUserPass = "W!ndowTa8k"
		$Privileges = "HIGHEST"
		$Schedule = "Daily"
		$Modifier = "1"
		$Days = "*"
		$Months = '"*"'
		$StartTime = "05:00"
		$EndTime = "17:00"
		$Interval = "60"
	
#	if (!(jobs.Contains($TaskName)))
#		{
		#Create a Script Directory if it does not exist already
		Write-Host "..."
		Write-Host
		Write-Host "Creating Scheduled Task on:" $Server -Foreground Yellow
		Write-Host 
		Write-Host "..."
	
		#Command to create Sheduld Task with 
		$Command = "schtasks.exe /create /s $Server /ru $RunAsUser /rp $RunAsUserPass /RL $Privileges  /tn $TaskName /tr $TaskRun /sc $Schedule /mo $Modifier /st $StartTime /F"
		Invoke-Expression $Command
		#Clear-Variable Command -ErrorAction SilentlyContinue
		Write-Host "`n"
#		}
#		else
#		{
#		Write-Host
#		Write-Host "Scheduled Task already exists!:" -Foreground Red
#		Write-Host
#		Write-Host "No Action will be taken at this time:" -Foreground Red
#		Write-Host 
#		Write-Host "..."
#		}
}	
 
# EXAMPLE: Create-ScheduledTask -ComputerName MyServer -TaskName MyTask02 -TaskRun "D:\scripts\script2.vbs"
#Create-ScheduledTask -ComputerName $ServerName -TaskName $TaskName -TaskRun $TaskRun

ForEach($Server in $ServerList) 
	{
	Map-to-Server ($Server)
	AddToGroup($Server)
	Create-Folder($Server)
	Create-ScheduledTask($Server)
	}

#Remove any mapped shares 
net use $RemotePath /delete /y

PAUSE