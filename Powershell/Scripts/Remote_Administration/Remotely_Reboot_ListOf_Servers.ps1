
#$MyServer = Read-Host "Please enter the Server name to REBOOT"
$MyDomain = "PROD"
$MyDrive = "C$"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword
$ServerList = (get-content "U:\TMP\E-stuff\Scripting\Powershell\Scripts\Remote_Administration\ListOfServers.txt")
$RemotePath = "\\$ServerList\$MyDrive"

#$Cred = Get-Credential $MyDomain\$MyUserName
#net use $RemotePath /user:$MyDomain\$MyUserName
#net use $RemotePath $Mypassword /user:$MyDomain\$MyUserName 

#Connect to Server by mapping to network drive
#net use $RemotePath /user:$MyUserName

Write-Output "----------------------"
Write-Output " "
Write-Host "Stopping IIS for server:" -foreground green $ServerList
Write-Output " " 
Write-Output "----------------------"
Write-Output " "

Invoke-Command -ComputerName $ServerList { Stop-Service W3SVC } -credential $Credentials
Write-Output " "

Write-Output " "
Write-Output " "
Write-Host "Waiting 30 sec for "$ServerList" to be removed from VIP:" -foreground yellow 
Write-Output " "
Write-Output " "

Start-Sleep -s 30

Write-Output "----------"
Write-Output " "
Write-Host "Restarting :" -foreground green $ServerList 
Write-Output " "
Write-Output "----------"
Write-Output " "

#Restart Server 
#Restart-Computer $MyServer -Force
Restart-Computer $ServerList -credential $Credentials -Force

#Ping server to assure that it it being rebooted
test-connection -Computername $ServerList -BufferSize 16 -Count 60

PAUSE