#Requires -version 5

if ($ENV:PACKER_BUILDER_TYPE -eq "vmware-iso") {
    # VMware tools
    $iso_url  = 'https://packages.vmware.com/tools/releases/10.3.10/windows/VMware-tools-windows-10.3.10-12406962.iso'
    $iso_path = "C:\Windows\Temp\windows.iso"
    (New-Object Net.WebClient).DownloadFile($iso_url, $iso_path) 
} else {
    # VirtualBox Additions
    $iso_url  = 'https://download.virtualbox.org/virtualbox/6.0.6/VBoxGuestAdditions_6.0.6.iso'
    $iso_path = "C:\Windows\Temp\windows.iso"
    (New-Object Net.WebClient).DownloadFile($iso_url, $iso_path) 
}

If (Test-Path $iso_path) {
    Write-Output "Mounting disk image at $iso_path"
    Mount-DiskImage -ImagePath $iso_path
    $iso_mounted_drv = ((Get-DiskImage -ImagePath $iso_path | Get-Volume).Driveletter  + ':')
    robocopy $iso_mounted_drv c:\windows\temp\vmtools /mir /timfix /np /nfl /ndl /r:0 
    # https://blogs.technet.microsoft.com/deploymentguys/2008/06/16/robocopy-exit-codes/ 
    Start-Sleep 5
}

function vmware {
    #$exe = ((Get-DiskImage -ImagePath $iso_path | Get-Volume).Driveletter + ':\setup.exe')
    $exe = 'c:\windows\temp\vmtools\setup.exe'
    $parameters = '/S /v "/qn REBOOT=R ADDLOCAL=ALL"'
    Start-Process $exe $parameters -Wait
}

function virtualbox {
    If (Test-Path $iso_path) {
        #$certdir = ((Get-DiskImage -ImagePath $iso_path | Get-Volume).Driveletter + ':\cert\')
        $certdir = 'c:\windows\temp\vmtools\cert\'
        $VBoxCertUtil = ($certdir + 'VBoxCertUtil.exe')
        
        if (Test-Path ($VBoxCertUtil)) {
            Write-Output "Using newer (4.4 and above) certificate import method"
        	Get-ChildItem $certdir *.cer | ForEach-Object { & $VBoxCertUtil add-trusted-publisher $_.FullName --root $_.FullName}
        }

        #$exe = ((Get-DiskImage -ImagePath $iso_path | Get-Volume).Driveletter + ':\VBoxWindowsAdditions.exe')
        $exe = 'c:\windows\temp\vmtools\VBoxWindowsAdditions.exe'
        $parameters = '/S'
        Start-Process $exe $parameters -Wait
    } else {
        $vboxaddondrv = gcim win32_logicaldisk | Where-Object { $_.volumename -like "*vbox*" }
        if (($vboxaddondrv | Measure-Object).Count -gt 0) {
            robocopy $vboxaddondrv.DeviceID c:\windows\temp\vmtools /mir /timfix /np /nfl /ndl /r:0 
            # https://blogs.technet.microsoft.com/deploymentguys/2008/06/16/robocopy-exit-codes/ 
            Start-Sleep 10

            $certdir = 'c:\windows\temp\vmtools\cert\'
            $VBoxCertUtil = ($certdir + 'VBoxCertUtil.exe')
            if (Test-Path ($VBoxCertUtil)) {
                Write-Output "Using newer (4.4 and above) certificate import method"
            	Get-ChildItem $certdir *.cer | ForEach-Object { & $VBoxCertUtil add-trusted-publisher $_.FullName --root $_.FullName}
            }

            $exe = 'c:\windows\temp\vmtools\VBoxWindowsAdditions.exe'
            $parameters = '/S'
            Start-Process $exe $parameters -Wait
        }
    }
}

if ($ENV:PACKER_BUILDER_TYPE -eq "vmware-iso") {
    Write-Output "Installing VMWare Guest Tools"
    vmware
} else {
    Write-Output "Installing Virtualbox Guest Tools"
    virtualbox
}

#Time to clean up - dismount the image and delete the original ISO
If (Test-Path $iso_path) {
    Write-Output "Dismounting disk image $iso_path"
    Dismount-DiskImage -ImagePath $iso_path
    Write-Output "Deleting $iso_path"
    Remove-item -Force $iso_path
}

# Due to unexpected LASTEXITCODE of "robocopy"
# https://blogs.technet.microsoft.com/deploymentguys/2008/06/16/robocopy-exit-codes/ 
exit 0