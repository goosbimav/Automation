
$MyServer = Read-Host "Please enter the Server name to REBOOT"
$MyDomain = "PROD"
$MyDrive = "C$"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUserName , $Mypassword
$RemotePath = "\\$MyServer\$MyDrive"

#$Cred = Get-Credential $MyDomain\$MyUserName
net use $RemotePath /user:$MyDomain\$MyUserName
#net use $RemotePath $Mypassword /user:$MyDomain\$MyUserName

#Connect to Server by mapping to network drive
#net use $RemotePath /user:$MyUserName

Write-Output "----------------------"
Write-Output " "
Write-Host "Stopping IIS for server:" -foreground green $MyServer 
Write-Output " " 
Write-Output "----------------------"
Write-Output " "

Invoke-Command -ComputerName $MyServer { Stop-Service W3SVC } -credential $Credentials
Write-Output " "

Write-Output " "
Write-Output " "
Write-Host "Waiting 60 sec for "$MyServer" to be removed from VIP:" -foreground yellow 
Write-Output " "
Write-Output " "

Start-Sleep -s 60

Write-Output "----------"
Write-Output " "
Write-Host "Restarting :" -foreground green $MyServer 
Write-Output " "
Write-Output "----------"
Write-Output " "

#Restart Server 
Restart-Computer $MyServer -credential $Credentials -Force

#Ping server to assure that it it being rebooted
test-connection -Computername $MyServer -BufferSize 16 -Count 60

PAUSE