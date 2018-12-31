
Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Power\ -name HiberFileSizePercent -value 0
Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Power\ -name HibernateEnabled -value 0

& powercfg.exe /H off
& powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
