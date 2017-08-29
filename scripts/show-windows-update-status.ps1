# See 
#  https://blogs.technet.microsoft.com/nanoserver/2016/10/07/updating-nano-server/
#  https://docs.microsoft.com/en-us/windows-server/get-started/update-nano-server
#
#$ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
#Invoke-CimMethod -InputObject $ci -MethodName ApplyApplicableUpdates
Write-Host 'Installed Update(s) status:'
Get-HotFix | Format-Table -AutoSize

Write-Host 'Checking available update(s) status:'
$ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession  
$result = $ci | Invoke-CimMethod -MethodName ScanForUpdates -Arguments @{SearchCriteria="IsInstalled=0";OnlineScan=$true}
$result.Updates | Format-Table -AutoSize
