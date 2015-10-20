#Restore IIS
@echo -----------------------------
@echo Restore Up IIS...
@echo ----------------------------- 

%windir%\system32\inetsrv\appcmd.exe add restore "IISBackup09202015"

@echo -----------------------------
@echo Restore Completed.
@echo -----------------------------
Pause