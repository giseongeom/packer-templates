$wmf51_file_url = 'http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu'
Invoke-WebRequest -Uri $wmf51_file_url -OutFile C:\Windows\temp\wmf51.msu -UseBasicParsing
Start-Process -wait wusa.exe -ArgumentList 'C:\Windows\Temp\wmf51.msu /extract:C:\Windows\temp\wmf51src'
dism.exe /online /add-package /norestart /quiet /PackagePath:C:\Windows\temp\wmf51src\WindowsBlue-KB3191564-x64.cab
exit 0
