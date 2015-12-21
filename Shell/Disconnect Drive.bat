@echo off
net use * /delete /y
taskkill /f /IM explorer.exe
explorer.exe