@echo off
cd /d c:\windows\temp\sysprep 

IF EXIST var-adv-sysprep.xml (
  start /wait c:\windows\system32\sysprep\sysprep.exe /quiet /generalize /oobe /shutdown /unattend:var-adv-sysprep.xml
)

IF EXIST sysprep.xml (
  start /wait c:\windows\system32\sysprep\sysprep.exe /quiet /generalize /oobe /shutdown /unattend:sysprep.xml
)

exit 0
