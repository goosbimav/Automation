@echo off
 
REM - The below option involkes an xml file parameter passing it to the powershell script outside of the script arguments, allowing the powershell script to be more generic. 

set cwd=%cd%

cd /d %cwd%

powershell -Command ".\FindandReplacePowershellScript.ps1"

cd /d %cwd%

echo ...


