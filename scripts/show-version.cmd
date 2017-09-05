@echo off
echo Powershell Version
powershell.exe -ExecutionPolicy bypass -windowstyle hidden -Command "$PSVersionTable"
echo Hostname: %COMPUTERNAME%
echo Username: %USERNAME%
systeminfo