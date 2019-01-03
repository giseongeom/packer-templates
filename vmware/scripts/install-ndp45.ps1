
$ndp45_url  = 'http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe'
$ndp45_path = 'C:\Windows\temp\NDP452-KB2901907-x86-x64-AllOS-ENU.exe' 
(New-Object Net.WebClient).DownloadFile($ndp45_url, $ndp45_path) 

IF (Test-Path $ndp45_path) {
    Start-Process -Wait -FilePath $ndp45_path -ArgumentList '/q /norestart' -NoNewWindow -Verbose
} 

# To avoid unexpected $LASTEXITCODE other than 0 (zero)
exit 0