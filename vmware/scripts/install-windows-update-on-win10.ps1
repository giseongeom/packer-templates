#Requires -version 5

# See 
# https://www.altaro.com/msp-dojo/powershell-windows-updates/

Import-Module PSWindowsUpdate -force
$updates = Get-wulist -verbose

# cleanup
if ((get-ScheduledTask -TaskName PSWindowsUpdate -ErrorAction SilentlyContinue | Measure-Object).count -gt 0) { 
    Remove-Item -Force -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log
    Unregister-ScheduledTask -TaskName PSWindowsUpdate -Confirm:$false
}

# install
if ($null -ne $updates) {
    $WUJob_Script = {import-module PSWindowsUpdate; Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot  | Out-File C:\Windows\Temp\PSWindowsUpdate.log}
    Invoke-WUjob -Confirm:$false -RunNow -Script $WUJob_Script

    "Currently processing the following update:"
    While ((Get-ScheduledTask -TaskName pswindowsupdate).state -eq 'Running') {
        Get-Content -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log | select-object -last 1
        Start-Sleep 15
    }

    if ((Get-ScheduledTask -TaskName pswindowsupdate).state -eq 'Ready') {
        Remove-Item -Force -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log
        Unregister-ScheduledTask -TaskName PSWindowsUpdate -Confirm:$false
    }
}

