#Requires -version 5

if ($ENV:PACKER_BUILDER_TYPE -eq "vmware-iso") {
    # VMware tools 10.3.5
    $iso_url = 'https://packages.vmware.com/tools/esx/latest/windows/VMware-tools-windows-10.3.5-10430147.iso'
    $iso_path = "C:\Windows\Temp\windows.iso"
    (New-Object Net.WebClient).DownloadFile($iso_url, $iso_path) 
}
else {
    # VirtualBox 6.0.0
    $iso_url = 'https://download.virtualbox.org/virtualbox/6.0.0/VBoxGuestAdditions_6.0.0.iso'
    $iso_path = "C:\Windows\Temp\windows.iso"
    (New-Object Net.WebClient).DownloadFile($iso_url, $iso_path) 
}
$iso_extracted_path = "C:\Windows\temp\vmtools"
Write-Output "Extracting disk image to $iso_extracted_path ......"
7z x -bd -bb0 -oC:\windows\temp\vmtools $iso_path


function vmware {
    # VMware Tools 10.3 requires Visual Studio 2017 redistributable as a prerequisite. 
    # https://kb.vmware.com/s/article/55798
    $exe = 'c:\windows\temp\vmtools\setup.exe'
    $parameters = '/S /v "/qn REBOOT=R ADDLOCAL=ALL"'
    Start-Process -FilePath $exe -ArgumentList $parameters -Wait -Verbose
}

function virtualbox {
    $certdir = ($iso_extracted_path + '\cert\')
    $VBoxCertUtil = ($certdir + 'VBoxCertUtil.exe')
    
    # Added support for VirtualBox 4.4 and above by doing this silly little trick.
    # We look for the presence of VBoxCertUtil.exe and use that as the deciding factor for what method to use.
    # The better way to do this would be to parse the Virtualbox version file that Packer can upload, but this was quick.
    
    if (Test-Path ($VBoxCertUtil)) {
        Write-Output "Using newer (4.4 and above) certificate import method"
        Get-ChildItem $certdir *.cer | ForEach-Object { & $VBoxCertUtil add-trusted-publisher $_.FullName --root $_.FullName}
    }
    
    $exe = 'c:\windows\temp\vmtools\VBoxWindowsAdditions.exe'
    $parameters = '/S'
    Start-Process -FilePath $exe -ArgumentList $parameters -Wait -Verbose
}


if ($ENV:PACKER_BUILDER_TYPE -eq "vmware-iso") {
    Write-Output "Installing VMWare Guest Tools"
    vmware
}
else {
    Write-Output "Installing Virtualbox Guest Tools"
    virtualbox
}

# Due to unexpected LASTEXITCODE of "robocopy"
# https://blogs.technet.microsoft.com/deploymentguys/2008/06/16/robocopy-exit-codes/ 
exit 0
