$ServerList = (get-content "C:\Scripts\serverList.txt")
$MyDomain = "HBPNA"
#$MyDrive = "D$"
$MyUserName = Read-Host 'Please enter a user name to use'
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$RemotePath = "\\$MyServer\$MyDrive"
##$FullRemotePath = "\\$MyServer\$MyDrive\LogFiles\SeoSite"
#$FullRemotePath = "\\$MyServer\$MyDrive\LogFiles\"

#$Cred = Get-Credential $MyDomain\$MyUserName
#net use $RemotePath /user:$MyDomain\$MyUserName
net use $RemotePath /user:$MyUserName
#New-PSDrive –Name “K” –PSProvider FileSystem –Root “\\touchsmart\share” –Persist

#Write-Output "----------------------------------------"
#Write-Output " "
#Write-Host "THE LATEST LOG FOLDER IS:" -foreground yellow $LatestLogFolder.name 
#Write-Output "----------------------------------------"
#Write-Output " "
#Write-Host "THE LATEST LOG FILE NAME IS:" -foreground yellow $LatestLog.name 
#Write-Output " "
#Write-Output " "
#Write-Output "------------------"
#Write-Host "LOG FILE RESULTS:" -foreground green
#Write-Output "------------------"
#Write-Output " "

Invoke-Command -ComputerName $ServerList { NET USE } -credential $Credentials

Invoke-Command -Session $s -ScriptBlock {$services = Get-Service}