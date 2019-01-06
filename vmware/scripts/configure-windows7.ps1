# Supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

# Set network to private
$ifaceinfo = Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex $ifaceinfo.InterfaceIndex -NetworkCategory Private 

# Set up WinRM and configure some things
# https://support.microsoft.com/en-us/help/2742246/how-to-troubleshoot-the-needs-attention-and-not-responding-host-status
# http://www.isolation.se/the-request-size-exceeded-the-configured-maxenvelopesize-quota/
Enable-PSRemoting -SkipNetworkProfileCheck -Force
winrm quickconfig -q
winrm set "winrm/config" '@{MaxTimeoutms="3600000"}'
winrm set "winrm/config" '@{MaxEnvelopeSizekb=”16384"}'
winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="4096"}'
winrm set "winrm/config/winrs" '@{MaxProcessesPerShell="100"}'
winrm set "winrm/config/winrs" '@{MaxConcurrentUsers="100"}'
winrm set "winrm/config/winrs" '@{MaxShellsPerUser="100"}'
winrm set "winrm/config/client" '@{AllowUnencrypted="true"}'
winrm set "winrm/config/client/auth" '@{Basic="true"}'
winrm set "winrm/config/service" '@{MaxConcurrentOperationsPerUser="1500"}'
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
& powercfg.exe /H off
& powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
