#Requires -version 5


if ($ENV:PACKER_BUILDER_TYPE -eq "vmware-iso") {
  # VMware tools 10.3.5
  $iso_url  = 'https://packages.vmware.com/tools/esx/latest/windows/VMware-tools-windows-10.3.5-10430147.iso'
  $iso_path = "C:\Windows\Temp\windows.iso"
  (New-Object Net.WebClient).DownloadFile($iso_url, $iso_path) 
} else {
  # VirtualBox 6.0.0
  $iso_url  = 'https://download.virtualbox.org/virtualbox/6.0.0/VBoxGuestAdditions_6.0.0.iso'
  $iso_path = "C:\Windows\Temp\windows.iso"
  (New-Object Net.WebClient).DownloadFile($iso_url, $iso_path) 
}

# Set the path of the VMWare Tools ISO - this is set in the Packer JSON file
$isopath = "C:\Windows\Temp\windows.iso"

# Mount the .iso, then build the path to the installer by getting the Driveletter attribute from Get-DiskImage piped into Get-Volume and adding a :\setup.exe
# A separate variable is used for the parameters. There are cleaner ways of doing this. I chose the /qr MSI Installer flag because I personally hate silent installers
# Even though our build is headless. 

If (Test-Path $isopath) {
    Write-Output "Mounting disk image at $isopath"
    Mount-DiskImage -ImagePath $isopath
}

function vmware {
    $exe = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\setup.exe')
    $parameters = '/S /v "/qn REBOOT=R ADDLOCAL=ALL"'
    
    Start-Process $exe $parameters -Wait
}

function virtualbox {
   
    If (Test-Path $isopath) {
        $certdir = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\cert\')
        $VBoxCertUtil = ($certdir + 'VBoxCertUtil.exe')
        
        # Added support for VirtualBox 4.4 and above by doing this silly little trick.
        # We look for the presence of VBoxCertUtil.exe and use that as the deciding factor for what method to use.
        # The better way to do this would be to parse the Virtualbox version file that Packer can upload, but this was quick.
        
        if (Test-Path ($VBoxCertUtil)) {
            Write-Output "Using newer (4.4 and above) certificate import method"
        	Get-ChildItem $certdir *.cer | ForEach-Object { & $VBoxCertUtil add-trusted-publisher $_.FullName --root $_.FullName}
        }
        else {
            Write-Output "Using older (4.3 and below) certificate import method"
        	$certpath = ($certpath + 'oracle-vbox.cer')
        	certutil -addstore -f "TrustedPublisher" $certpath
        }
 
        $exe = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\VBoxWindowsAdditions.exe')
        $parameters = '/S'
        Start-Process $exe $parameters -Wait
    } else {
        $vboxaddondrv = gcim win32_logicaldisk | Where-Object { $_.volumename -like "*vbox*" }
        if (($vboxaddondrv | Measure-Object).Count -gt 0) {
            robocopy $vboxaddondrv.DeviceID c:\windows\temp\vboxdrv /mir /timfix /np /nfl /ndl /r:0 
            Start-Sleep 10

            $certdir = 'c:\windows\temp\vboxdrv\cert\'
            $VBoxCertUtil = ($certdir + 'VBoxCertUtil.exe')
            if (Test-Path ($VBoxCertUtil)) {
                Write-Output "Using newer (4.4 and above) certificate import method"
            	Get-ChildItem $certdir *.cer | ForEach-Object { & $VBoxCertUtil add-trusted-publisher $_.FullName --root $_.FullName}
            } else {
                Write-Output "Using older (4.3 and below) certificate import method"
            	$certpath = ($certpath + 'oracle-vbox.cer')
            	certutil -addstore -f "TrustedPublisher" $certpath
            }

            $exe = 'c:\windows\temp\vboxdrv\VBoxWindowsAdditions.exe'
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
If (Test-Path $isopath) {
    Write-Output "Dismounting disk image $isopath"
    Dismount-DiskImage -ImagePath $isopath
    Write-Output "Deleting $isopath"
    Remove-Item $isopath
}
