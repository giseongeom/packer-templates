#Requires -version 5

# See 
#  https://blogs.technet.microsoft.com/nanoserver/2016/10/07/updating-nano-server/
#  https://docs.microsoft.com/en-us/windows-server/get-started/update-nano-server
$os_version = (gcim Win32_operatingsystem).Version
 
# Windows Server 2016
if ($os_version -like '10.*') {
    $ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
    $ApplicableUpdateList = $ci | Invoke-CimMethod -MethodName ScanForUpdates -Arguments @{SearchCriteria = "IsInstalled=0"; OnlineScan = $true}
    # Show windows updates to be installed
    $ApplicableUpdateList.Updates
    # Apply updates
    Invoke-CimMethod -InputObject $ci -MethodName ApplyApplicableUpdates
}
