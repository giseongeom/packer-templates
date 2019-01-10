#Requires -version 5

# See 
# https://www.altaro.com/msp-dojo/powershell-windows-updates/

Import-Module PSWindowsUpdate -force
$updates = Get-wulist -Verbose

# cleanup
$pswindows_update_task = (get-ScheduledTask -TaskName PSWindowsUpdate -ErrorAction SilentlyContinue)
if (($pswindows_update_task.TaskName.length -gt 0) -And ($pswindows_update_task.Status -eq 'Ready')) {
    Unregister-ScheduledTask -TaskName PSWindowsUpdate -Confirm:$false
}

# install
if ($null -ne $updates) {
    Remove-Item -Force -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log
    $WUJob_Script = {import-module PSWindowsUpdate; Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot | Out-File C:\Windows\Temp\PSWindowsUpdate.log}
    Invoke-WUjob -Confirm:$false -RunNow -Script $WUJob_Script

    "Currently processing the following update:"
    Start-Sleep 30
    $log1 = ''
    $log2 = ''
    While ($true) {
        $pswindows_update_task = (get-ScheduledTask -TaskName PSWindowsUpdate -ErrorAction SilentlyContinue)
        $pswindows_powershell_process = (gcim win32_process -Filter "name = 'powershell.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*PSWindowsUpdate*" } | measure-object)
        if (($pswindows_update_task.Status -ne 'Running') -And ($pswindows_powershell_process.Count -eq 0)) { Break }

        $log1=(Get-Content -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log | select-object -last 1)
        if ($log1 -ne $log2) { $log1 }
              
        Start-Sleep 10
        
        $log2=(Get-Content -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log | select-object -last 1)
        if ($log2 -ne $log1) { $log2 }
    }


    $pswindows_update_task = (get-ScheduledTask -TaskName PSWindowsUpdate -ErrorAction SilentlyContinue)
    if ($pswindows_update_task.Status -eq 'Ready') {
        Unregister-ScheduledTask -TaskName PSWindowsUpdate -Confirm:$false
    }
}

