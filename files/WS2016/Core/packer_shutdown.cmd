@echo off
netsh advfirewall firewall set rule name="WinRM-HTTP" new action=block
start /wait c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:C:\windows\Panther\Unattend\unattend.xml
exit 0

