@echo off

for /f %%a in (TBServers.txt) do (Set fname=%%a) & call :execute
goto :eof

:execute
psexec \\%fname% C:/Windows/system32/inetsrv/appcmd.exe start site /site.name:"TBJobSearch"


timeout 3