#Backup IIS
@echo -----------------------------
@echo Backing Up IIS...
@echo ----------------------------- 

%windir%\system32\inetsrv\appcmd.exe delete backup "IISBackup09202015"
%windir%\system32\inetsrv\appcmd.exe delete backup "testbackup"

@echo -----------------------------
@echo Delete of backup Completed.
@echo -----------------------------
Pause
