
Set-Location 'C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts'
./InitializeInstance.ps1 -Schedule
Start-Sleep 10
./SysprepInstance.ps1
