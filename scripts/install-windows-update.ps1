# See 
#  https://blogs.technet.microsoft.com/nanoserver/2016/10/07/updating-nano-server/
#  https://docs.microsoft.com/en-us/windows-server/get-started/update-nano-server
#
$ci = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
Invoke-CimMethod -InputObject $ci -MethodName ApplyApplicableUpdates