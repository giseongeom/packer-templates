# See 
#  https://blogs.technet.microsoft.com/nanoserver/2016/10/07/updating-nano-server/
#  https://docs.microsoft.com/en-us/windows-server/get-started/update-nano-server
$os_version = (gcim Win32_operatingsystem).Version
 
# Powershell 5+ on Windows Server 2012 R2
if (($PSVersionTable.PSVersion.Major -ge 5) -and ( $os_version -eq '6.3.9600')) {
  Write-Host 'Checking available update(s) status:'
  Get-WUInstall -RootCategories 'Critical Updates','Security Updates','Update Rollups' -MicrosoftUpdate -IgnoreUserInput -Verbose -AcceptAll -IgnoreReboot
}

# Windows Server 2016
if ($os_version -like '10.*') {
  $ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
  Invoke-CimMethod -InputObject $ci -MethodName ApplyApplicableUpdates
}
