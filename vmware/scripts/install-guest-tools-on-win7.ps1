#Requires -version 5

# Set the path of the VMWare Tools ISO - this is set in the Packer JSON file
$isopath = "C:\Windows\Temp\windows.iso"
$iso_extracted_path = "C:\Windows\temp\vmtools"
Write-Output "Extracting disk image to $iso_extracted_path ......"
7z x -bd -bb0 -oC:\windows\temp\vmtools $isopath


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
} else {
    Write-Output "Installing Virtualbox Guest Tools"
    virtualbox
}

#Time to clean up - dismount the image and delete the original ISO
#Write-Output "Removing disk image $iso_extracted_path"
#Remove-Item $iso_extracted_path -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
#Write-Output "Deleting $isopath"
#Remove-Item $isopath
