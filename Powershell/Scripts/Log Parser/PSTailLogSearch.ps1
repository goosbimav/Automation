
$MyServer = Read-Host "Please enter the Server name"
$MyDomain = "PROD"
$MyDrive = "D$"
$MyUserName = Read-Host "Enter User Name to use"
$Mypassword = Read-Host 'Please enter your network password' -AsSecureString
$RemotePath = "\\$MyServer\$MyDrive"
#$FullRemotePath = "\\$MyServer\$MyDrive\LogFiles\SeoSite"
$FullRemotePath = "\\$MyServer\$MyDrive\LogFiles\"
$OutputFile = "U:\TMP\Toolbar\T\Tools\Log Parsers\LogOutput\IISlogOutput.txt"

#Sort the logs folder within the logs directory by last write time
$LatestLogFolder = Get-ChildItem -Path $FullRemotePath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

#Append the logs directory file path with the latest log folder name determined from above
$LatestLogPath = $FullRemotePath + $LatestLogFolder

#Sort the log files by last write time within the latest log folder path identified above
$LatestLog = Get-ChildItem -Path $LatestLogPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1
#$Cred = Get-Credential $MyDomain\$MyUserName
#net use $RemotePath /user:$MyDomain\$MyUserName
net use $RemotePath /user:$MyUserName

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

#Output the line with specific search string value
###################################################
#Get-Content $LatestLogPath\$LatestLog -wait | where { $_ -match “Connection Timeout Expired” }
#Get-Content $LatestLogPath\$LatestLog -wait | where { $_ -match “SqlException” }
#Get-Content $LatestLogPath\$LatestLog -wait | where { $_ -match “System.Data.SqlClient.SqlException” }

#Output the line with specific search string value into an OUTPUT FILE
###################################################
Get-Content $LatestLogPath\$LatestLog -wait | where { $_ -match “Connection Timeout Expired” } | Out-File $OutputFile
#Get-Content $LatestLogPath\$LatestLog -wait | where { $_ -match “SqlException” } | Out-File $OutputFile
#Get-Content $LatestLogPath\$LatestLog -wait | where { $_ -match “System.Data.SqlClient.SqlException” } | Out-File $OutputFile

#Output the end of the log file
#Get-Content $FullRemotePath\$LatestLog -wait

PAUSE