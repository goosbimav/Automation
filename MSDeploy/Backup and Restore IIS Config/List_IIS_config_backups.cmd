#Restore IIS
@echo -----------------------------
@echo Restore Up IIS...
@echo ----------------------------- 

%windir%\system32\inetsrv\appcmd.exe list backup

@echo -----------------------------
@echo Restore Completed.
@echo -----------------------------
Pause