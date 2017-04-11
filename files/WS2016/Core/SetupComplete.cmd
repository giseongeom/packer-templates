@echo off
netsh advfirewall firewall set rule name="WinRM-HTTP" new action=allow
net accounts /MAXPWAGE:UNLIMITED
powershell.exe -ExecutionPolicy bypass -windowstyle hidden -file %~dp0SetupComplete_onboot.ps1

