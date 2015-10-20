@echo off
REM - File: FNIC Services.bat
REM - This script is only intended automate the STOP of system services on a remote machine.
REM - This will stop all Java services related to a specific platform on a specific box

REM - Set the current directory of the script before you do anything
set cwd=%cd%

REM - This argument is the file name the script looks for and has to be passed along with the script
REM - set servername1=%1

echo ========================
echo Stopping System Services
echo ========================

timeout /t 3

sc \\dtpsw101.prod.corp.ad stop "TermService"

echo ...

cd /d %cwd%

echo =========
echo FINISHED!
echo =========

timeout /t 3