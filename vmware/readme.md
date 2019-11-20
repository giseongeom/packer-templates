Packer templates (VMware/VirtualBox)
============================


## Supported

* Windows 7 Enterprise / 64-bit
  * Windows 7 with SP1 English / Korean
* Windows 10 SAC (Semi-Annual Channel) / 64-bit
  * Enterprise English / Korean / Evaluation
* Windows 10 LTSC (Long-Term Servicing Channel) / 64-bit
  * LTSC 2019 Enterprise English / Korean / Evaluation
* Windows Server SAC (Semi-Annual Channel) 
  * Datacenter English (Server Core)
* Windows Server LTSC (Long-Term Servicing Channel) 2019 
  * LTSC 2019 Datacenter English / Korean / Evaluation (with Desktop experience)
  * LTSC 2019 Datacenter English (Server Core)
* Windows Server LTSB (Long-Term Servicing Branch) 2016 
  * LTSB 2016 Datacenter English / Korean / Evaluation (with Desktop experience)
  * LTSB 2016 Datacenter English (Server Core)
* Windows Server 2012 R2 Datacenter
  * 2012 R2 English / Korean / Evaluation (with Desktop experience)
  * 2012 R2 English (Server Core)
* Windows Server 2008 R2 Enterprise
  * 2008 R2 with SP1 English / Korean / Evaluation (with Desktop experience)
  * 2008 R2 with SP1 English (Server Core)
* Ubuntu
  * Ubuntu Server 16.04 / 64-bit


## Test/Build Environment

* packer 1.3.3
* Windows 10 1809 (64-bit)
* VMware Workstation 15.0.2
* VirtualBox 5.2.22
* Visual Studio Code
* Conemu
* Powershell 6


## HOW-TO-BUILD

* VMware
`packer build -only=vmware-iso win10-SAC-1809-eval.json`
* Virtualbox
`packer build -only=virtualbox-iso win10-SAC-1809-eval.json`


### Examples
* Windows 10 SAC 1809 Evaluation

```powershell
PS C:\> packer build -only=vmware-iso .\win10-SAC-1809-eval.json
vmware-iso output will be in this color.

==> vmware-iso: Retrieving ISO
    vmware-iso: Found already downloaded, initial checksum matched, no download needed: https://software-download.microsoft.com/download/sg/17763.107.101029-1455.rs5_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
==> vmware-iso: Creating floppy disk...
    vmware-iso: Copying files flatly from floppy_files
    vmware-iso: Copying file: win10/Win_10_ENT_SAC_1809_Eval/Autounattend.xml
    vmware-iso: Copying file: scripts/configure-windows10.ps1
    vmware-iso: Done copying files from floppy_files
    vmware-iso: Collecting paths from floppy_dirs
    vmware-iso: Resulting paths from floppy_dirs : []
    vmware-iso: Done copying paths from floppy_dirs
==> vmware-iso: Creating required virtual machine disks
==> vmware-iso: Building and writing VMX file
==> vmware-iso: Starting virtual machine...
==> vmware-iso: Waiting for WinRM to become available...
==> vmware-iso: Waiting for WinRM to become available...
    vmware-iso: WinRM connected.
    vmware-iso: #< CLIXML
==> vmware-iso: Connected to WinRM!
==> vmware-iso: Uploading the 'windows' VMware Tools
==> vmware-iso: Provisioning with Powershell...
==> vmware-iso: Provisioning with powershell script: ./scripts/install-ps-modules.ps1
    vmware-iso: VERBOSE: Using the provider 'Bootstrap' for searching packages.
    vmware-iso: VERBOSE: Performing the operation "Install Package" on target "Package 'nuget' version '2.8.5.208' from
    vmware-iso: 'https://oneget.org/nuget-2.8.5.208.package.swidtag'.".
    vmware-iso: VERBOSE: Installing the package 'https://oneget.org/nuget-2.8.5.208.package.swidtag'.
==> vmware-iso: Provisioning with powershell script: ./scripts/install-guest-tools.ps1
    vmware-iso: Mounting disk image at C:\Windows\Temp\windows.iso
    vmware-iso:
    vmware-iso:
    vmware-iso: Attached          : True
    vmware-iso: BlockSize         : 0
    vmware-iso: DevicePath        : \\.\CDROM1
    vmware-iso: FileSize          : 121536512
    vmware-iso: ImagePath         : C:\Windows\Temp\windows.iso
    vmware-iso: LogicalSectorSize : 2048
    vmware-iso: Number            : 1
    vmware-iso: Size              : 121536512
    vmware-iso: StorageType       : 1
    vmware-iso: PSComputerName    :
    vmware-iso:
    vmware-iso: Installing VMWare Guest Tools
    vmware-iso: Dismounting disk image C:\Windows\Temp\windows.iso
    vmware-iso: Attached          : False
    vmware-iso: BlockSize         : 0
    vmware-iso: DevicePath        :
    vmware-iso: FileSize          : 121536512
    vmware-iso: ImagePath         : C:\Windows\Temp\windows.iso
    vmware-iso: LogicalSectorSize : 2048
    vmware-iso: Number            :
    vmware-iso: Size              : 121536512
    vmware-iso: StorageType       : 1
    vmware-iso: PSComputerName    :
    vmware-iso:
    vmware-iso: Deleting C:\Windows\Temp\windows.iso
==> vmware-iso: Restarting Machine
==> vmware-iso: Waiting for machine to restart...
    vmware-iso: A system shutdown is in progress.(1115)
    vmware-iso: VAGRANT-FKSRUP0 restarted.
==> vmware-iso: Machine successfully restarted, moving on
==> vmware-iso: Uploading ./win10/Win_10_ENT_SAC_1809_Eval/sysprep/ => c:/windows/temp/sysprep
==> vmware-iso: Uploading ./scripts/packer_shutdown_win10.cmd => c:/windows/temp/packer_shutdown.cmd
1 items:  387 B / 387 B  0s
==> vmware-iso: Uploading ./scripts/SetupComplete_win10.cmd => c:/windows/setup/scripts/SetupComplete.cmd
1 items:  759 B / 759 B  0s
==> vmware-iso: Provisioning with Powershell...
==> vmware-iso: Provisioning with powershell script: ./scripts/install-windows-update-on-win10.ps1
    vmware-iso: VERBOSE: VAGRANT-FKSRUP0 (12/22/2018 7:16:52 PM): Connecting to Windows Update server. Please wait...
    vmware-iso: VERBOSE: Found [6] Updates in pre search criteria
    vmware-iso: VERBOSE: Found [6] Updates in post search criteria
    vmware-iso: Currently processing the following update:
    vmware-iso: 2 VAGRANT-F... Downloaded KB4470502   53MB 2018-12 Cumulative Update for .NET Framework 3.5 and 4.7.2 for Windows 10...
    vmware-iso: 2 VAGRANT-F... Downloaded KB2267602  130MB Definition Update for Windows Defender Antivirus - KB2267602 (Definition ...
    vmware-iso: 3 VAGRANT-F... Installed  KB4471331   21MB 2018-12 Security Update for Adobe Flash Player for Windows 10 Version 180...
    vmware-iso: 3 VAGRANT-F... Installed  KB890830    46MB Windows Malicious Software Removal Tool x64 - December 2018 (KB890830)
    vmware-iso: 3 VAGRANT-F... Installed  KB4470502   53MB 2018-12 Cumulative Update for .NET Framework 3.5 and 4.7.2 for Windows 10...
==> vmware-iso: Provisioning with powershell script: ./scripts/disable-autologin.ps1
==> vmware-iso: Provisioning with powershell script: ./scripts/disable-hibernate.ps1
==> vmware-iso: Restarting Machine
==> vmware-iso: Waiting for machine to restart...
    vmware-iso: A system shutdown is in progress.(1115)
    vmware-iso: VAGRANT-FKSRUP0 restarted.
==> vmware-iso: Machine successfully restarted, moving on
==> vmware-iso: Pausing 10s before the next provisioner...
==> vmware-iso: Provisioning with Powershell...
==> vmware-iso: Provisioning with powershell script: ./scripts/install-windows-update-on-win10.ps1
    vmware-iso: VERBOSE: VAGRANT-FKSRUP0 (12/22/2018 7:24:46 PM): Connecting to Windows Update server. Please wait...
    vmware-iso: VERBOSE: Found [0] Updates in pre search criteria
==> vmware-iso: Restarting Machine
==> vmware-iso: Waiting for machine to restart...
    vmware-iso: #< CLIXML
    vmware-iso: VAGRANT-FKSRUP0 restarted.
==> vmware-iso: Provisioning with Powershell...
==> vmware-iso: Provisioning with powershell script: C:\Users\giseong.eom\AppData\Local\Temp\packer-powershell-provisioner890499819
==> vmware-iso: Gracefully halting virtual machine...
    vmware-iso: Waiting for VMware to clean up after itself...
==> vmware-iso: Deleting unnecessary VMware files...
==> vmware-iso: Cleaning VMX prior to finishing up...
    vmware-iso: Detaching ISO from CD-ROM device sata0:0...
    vmware-iso: Unmounting floppy0 from VMX...
==> vmware-iso: Skipping export of virtual machine (export is allowed only for ESXi)...
Build 'vmware-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> vmware-iso: VM files in directory: %!s(<nil>)
```