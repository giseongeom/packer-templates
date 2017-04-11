# See http://www.pctools.com/guides/registry/detail/1176/
New-ItemProperty -Name NoAutoUpdate -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -PropertyType DWord -Value 1