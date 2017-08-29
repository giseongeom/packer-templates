# See 
#  https://blogs.technet.microsoft.com/nanoserver/2016/10/07/updating-nano-server/
#  https://docs.microsoft.com/en-us/windows-server/get-started/update-nano-server
#
#$ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
#Invoke-CimMethod -InputObject $ci -MethodName ApplyApplicableUpdates
Write-Host 'Installed Update(s) status:'
Get-HotFix | Format-Table -AutoSize
$os_version = (gcim Win32_operatingsystem).Version

# Powershell 5+ on Windows Server 2012 R2
if (($PSVersionTable.PSVersion.Major -ge 5) -and ( $os_version -eq '6.3.9600')) {
  Install-PackageProvider -Name NuGet -Force
  Set-PSRepository -InstallationPolicy Trusted -Name PSGallery
  Install-module -Name PSWindowsUpdate -Force
  Write-Host 'Checking available update(s) status:'
  Get-WUList -MicrosoftUpdate
}

# Windows Server 2016
if ($os_version -like '10.*') {
  Write-Host 'Checking available update(s) status:'
  $ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession  
  $result = $ci | Invoke-CimMethod -MethodName ScanForUpdates -Arguments @{SearchCriteria="IsInstalled=0";OnlineScan=$true}
  $result.Updates | Format-Table -AutoSize
}
