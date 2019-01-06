
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y 7zip.portable curl wget zip unzip

# To avoid unexpected $LASTEXITCODE other than 0 (zero)
exit 0