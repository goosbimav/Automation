$ServerName = Read-Host "Please enter the destination Server"
$MyDomain = "NEWYORK"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword
$MyDrive = "C$"
$RemotePath = "\\$ServerName\$MyDrive"
$CurrentPath = Set-Location
$SourcePath = $CurrentPath + "TestCopyOrigin"

#$Cred = Get-Credential $MyDomain\$MyUserName
#net use $RemotePath /user:$MyDomain\$MyUserName
#net use $RemotePath $Mypassword /user:$MyDomain\$MyUserName

#Connect to Server by mapping to network drive
#net use $RemotePath /user:$MyUserName


#Function that creates a folder on a remote server
Function Create-Folder($Server)
	{
	#Drive and folder related parameters:
	$RemotePath = "\\$ServerName\$MyDrive"
	$MyDrive = "C$"
	$DestDir = "$RemotePath\Test"
	
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

#Invoke-Command -ComputerName $MyServer { Stop-Service W3SVC } -credential $Credentials
Write-Output " "

Write-Output " "
Write-Output " "
Write-Host "Waiting 10 sec for "$MyServer" just for testing:" -foreground yellow 
Write-Output " "
Write-Output " "

Start-Sleep -s 10

Write-Output "----------"
Write-Output " "
Write-Host "Do something here :" -foreground green $MyServer 
Write-Output " "
Write-Output "----------"
Write-Output " "

#Restart Server 
#Restart-Computer $MyServer -credential $Credentials -Force

#Ping server to assure that it it being rebooted
#test-connection -Computername $ServerName -BufferSize 16 -Count 10

PAUSE