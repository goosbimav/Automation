cd /d C:\scripts\DelteOldFiles

powershell .\DeleteOldFiles.ps1 -FolderPath D:\Backup\SolarWinds\NTA\FlowStorage\Data -FileAge 30 -LogFile DeleteOldFilesLog.log -IncludeFileExtension '.zip*'
