@echo off
REM
REM https://www.top-password.com/blog/differences-between-user-account-expiration-and-password-expiration/
REM

net accounts /maxpwage:unlimited

net user Administrator /active:yes
net user Administrator /expires:never
WMIC USERACCOUNT WHERE Name='Administrator' SET PasswordExpires=FALSE

net user vagrant /expires:never
WMIC USERACCOUNT WHERE Name='vagrant' SET PasswordExpires=FALSE

IF EXIST c:\windows\temp\sysprep\var-windows.lic (
  FOR /F %%i in (c:\windows\temp\sysprep\var-windows.lic) do set PID=%%i
)

IF DEFINED PID (
  c:\windows\system32\cscript.exe c:\windows\system32\slmgr.vbs /cpky
  c:\windows\system32\cscript.exe c:\windows\system32\slmgr.vbs /ipk %PID%
  DEL /q /f c:\windows\temp\sysprep\var-windows.lic
)

IF EXIST c:\windows\temp\sysprep\var-adv-sysprep.xml (
  DEL /q /f c:\windows\temp\sysprep\var-adv-sysprep.xml
)

IF EXIST c:\windows\temp\sysprep\sysprep.xml (
  DEL /q /f c:\windows\temp\sysprep\sysprep.xml
)
