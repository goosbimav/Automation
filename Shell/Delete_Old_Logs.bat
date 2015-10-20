REM # Author: Gus Sbirakis
REM # Last Modified: 12/10/2014
REM # This script will delete old log files in the below directories based on a retention period

forfiles /p "C:\Logs" /s /d -30 /c "cmd /c del @file : date >= 90 days >NUL"
REM - forfiles /p "C:\Logstash" /s /d -30 /c "cmd /c del @file : date >= 90 days >NUL" 