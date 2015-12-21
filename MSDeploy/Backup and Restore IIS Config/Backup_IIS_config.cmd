#Backup IIS
@echo -----------------------------
@echo Backing Up IIS...
@echo ----------------------------- 

%windir%\system32\inetsrv\appcmd.exe add backup "IISBackup11232015"

@echo -----------------------------
@echo Backup Completed.
@echo -----------------------------
Pause
