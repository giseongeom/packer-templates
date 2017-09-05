@ECHO OFF && SETLOCAL && SETLOCAL ENABLEDELAYEDEXPANSION && SETLOCAL ENABLEEXTENSIONS
REM All commands will be executed during first Virtual Machine boot

del /q /f C:\Windows\Temp\sql.iso
powershell.exe -ExecutionPolicy bypass -windowstyle hidden -file %~dp0SetupComplete2-azure-with-sql-2016.ps1


