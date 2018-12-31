# Supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

# Set network to private
$ifaceinfo = Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex $ifaceinfo.InterfaceIndex -NetworkCategory Private 

# Set up WinRM and configure some things
Enable-PSRemoting -SkipNetworkProfileCheck -Force
winrm quickconfig -q
winrm set "winrm/config" '@{MaxTimeoutms="1800000"}'
winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="2048"}'
winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
winrm set "winrm/config/service/auth" '@{Basic="true"}'

sc.exe config winrm start= auto

# ScriptExecution Policy
Set-ExecutionPolicy RemoteSigned -Force

# create folders under c:\windows
New-Item -Path C:\Windows\temp\Sysprep -ItemType directory -Force
New-Item -Path C:\Windows\Setup\Scripts -ItemType directory -Force
New-Item -Path C:\Windows\Panther\Unattend -ItemType directory -Force

# No Expiration
net user Administrator /active:yes
net user Administrator /expires:never
WMIC USERACCOUNT WHERE Name='Administrator' SET PasswordExpires=FALSE
net user vagrant /expires:never
WMIC USERACCOUNT WHERE Name='vagrant' SET PasswordExpires=FALSE

# Disable Hibernation
powercfg /H off

exit 0
