#Requires -version 5

Install-PackageProvider -Name NuGet -Force -Verbose
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery -Verbose
Install-module -Name PSWindowsUpdate -Force -Verbose

$BuildVersion = [System.Environment]::OSVersion.Version
if ($BuildVersion.Major -lt '10') {
    Install-module -Name PSReadLine -Force -Verbose
}
