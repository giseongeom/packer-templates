# See http://www.thomasmaurer.ch/2016/07/how-to-disable-and-configure-windows-defender-on-windows-server-2016-using-powershell/
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -ExclusionPath "C:\Windows", "C:\Users", "C:\ProgramData"

