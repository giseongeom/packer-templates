#Requires -version 5

Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -name AutoAdminLogon -value 0
