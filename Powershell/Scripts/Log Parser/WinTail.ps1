############################################################################# 
## 
## Uses WinTail to open and tail the latest relevant log file on a target Server    
## Version : 1.0 
##
## This script tails the Log files on a remote server(s)
##
## Prerequisite:
##	
## 	
##
############################################################################## 


$Server = Read-Host "Please enter the Server name"
$MyDomain = Read-Host "Please enter the DOMAIN to use"
$MyDrive = "S$"
$MyUserName = Read-Host "Enter User Name to use"
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
#$Cred = Get-Credential $MyDomain\$MyUserName
$RemotePath = "\\$Server\$MyDrive"
$FullRemotePath = "\\$Server\$MyDrive\Logs\"

#Temporarily maps to each remote server for authentication

#Remove any previously mapped shares 
net use $RemotePath /delete /y

#net use $RemotePath /user:$MyDomain\$MyUserName
net use $RemotePath /user:$MyUserName


#Sort the logs folder within the logs directory by last write time
$LatestLogFolder = Get-ChildItem -Path $FullRemotePath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

#Append the logs directory file path with the latest log folder name determined from above
$LatestLogPath = $FullRemotePath + $LatestLogFolder

#Sort the log files by last write time within the latest log folder path identified above
$LatestLog = Get-ChildItem -Path $LatestLogPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

Write-Output "----------------------------------------"
Write-Output " "
Write-Host "THE LATEST LOG FOLDER IS:" -foreground yellow $LatestLogFolder.name 
Write-Output "----------------------------------------"
Write-Output " "
Write-Host "THE LATEST LOG FILE NAME IS:" -foreground yellow $LatestLog.name 
Write-Output " "
Write-Output " "
Write-Output "------------------"
Write-Host "LOG FILE RESULTS:" -foreground green
Write-Output "------------------"
Write-Output " "

#Run Executable "Wintail" with the latest written log file to tail
& "D:\E-stuff\Toolbar\T\Tools\Log Parsers\tail.exe" -d $LatestLogPath\$LatestLog

#Remove any previously mapped shares 
net use $RemotePath /delete /y

PAUSE