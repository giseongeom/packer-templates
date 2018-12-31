#Requires -version 5

# See 
# https://www.altaro.com/msp-dojo/powershell-windows-updates/

Import-Module PSWindowsUpdate -force
$updates = Get-wulist -AutoSelectOnWebSites -verbose

# cleanup
$pswindows_update_task = (schtasks /query /tn PSWindowsUpdate /FO CSV 2> null | ConvertFrom-Csv)
if (($pswindows_update_task.TaskName.length -gt 0) -And ($pswindows_update_task.Status -eq 'Ready')) {
    Remove-Item -Force -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log
    schtasks /Delete /tn PSWindowsUpdate /F
}

# install
if ($null -ne $updates) {
    $WUJob_Script = {import-module PSWindowsUpdate; Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot -AutoSelectOnWebSites | Out-File C:\Windows\Temp\PSWindowsUpdate.log}
    Invoke-WUjob -Confirm:$false -RunNow -Script $WUJob_Script

    "Currently processing the following update:"
    Start-Sleep 30
    $log1 = ''
    $log2 = ''
    While ((schtasks /query /tn PSWindowsUpdate /FO CSV | ConvertFrom-Csv).Status -eq 'Running') {
        $log1=(Get-Content -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log | select-object -last 1)
        if ($log1 -ne $log2) { $log1 }
              
        Start-Sleep 10
        
        $log2=(Get-Content -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log | select-object -last 1)
        if ($log2 -ne $log1) { $log2 }
    }

    if ((schtasks /query /tn PSWindowsUpdate /FO CSV | ConvertFrom-Csv).Status -eq 'Ready') {
        Remove-Item -Force -ErrorAction SilentlyContinue C:\Windows\temp\PSWindowsUpdate.log
        schtasks /Delete /tn PSWindowsUpdate /F
    }
}

