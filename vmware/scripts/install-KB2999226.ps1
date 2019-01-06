# To resolve installation requirement of VMware Tools 10.3.x for windows 
# https://kb.vmware.com/s/article/55798
# http://support.microsoft.com/kb/2999226
# https://support.microsoft.com/en-us/help/2999226/update-for-universal-c-runtime-in-windows

Function Get-OSVersion {
    [string]$returnValue = ''
    $BuildVersion = [System.Environment]::OSVersion.Version

    if ($BuildVersion.Major -ge '10') {
        $returnValue = 'win10'
    }

    ## OS is Windows 8.1
    if ($BuildVersion.Major -eq '6' -and $BuildVersion.Minor -eq '3') {
        $returnValue = 'win8.1'
    }

    ## OS is Windows 8
    if ($BuildVersion.Major -eq '6' -and $BuildVersion.Minor -eq '2') {
        $returnValue = 'win8'
    }

    ## OS is Windows 7
    if ($BuildVersion.Major -eq '6' -and $BuildVersion.Minor -eq '1') {
        $returnValue = 'win7'
    }

    ## OS is Windows Vista
    if ($BuildVersion.Major -eq '6' -and $BuildVersion.Minor -le '0') {
        $returnValue = 'vista'
    }

    ## OS is below Windows Vista
    if ($BuildVersion.Major -lt '6') {
        $returnValue = 'xp'
    }
    return $returnValue
}


Function install-KB2999226for2008r2 {
    $file_url = 'http://download.microsoft.com/download/1/1/5/11565A9A-EA09-4F0A-A57E-520D5D138140/Windows6.1-KB2999226-x64.msu'
    $file_path = 'C:\Windows\temp\Windows6.1-KB2999226-x64.msu' 
    (New-Object Net.WebClient).DownloadFile($file_url, $file_path) 

    If (Test-Path $file_path) {
        Start-Process -wait wusa.exe -ArgumentList 'C:\Windows\temp\Windows6.1-KB2999226-x64.msu /extract:C:\Windows\temp\KB2999226' -NoNewWindow
        dism.exe /online /add-package /norestart /quiet /PackagePath:C:\Windows\temp\KB2999226\Windows6.1-KB2999226-x64.cab
    }
}


Function install-KB2999226for2012r2 {
    $file_url = 'https://download.microsoft.com/download/D/1/3/D13E3150-3BB2-4B22-9D8A-47EE2D609FFF/Windows8.1-KB2999226-x64.msu'
    $file_path = 'c:\windows\temp\Windows8.1-KB2999226-x64.msu' 
    (New-Object Net.WebClient).DownloadFile($file_url, $file_path) 

    If (Test-Path $file_path) {
        Start-Process -wait wusa.exe -ArgumentList 'C:\Windows\temp\Windows8.1-KB2999226-x64.msu /extract:C:\Windows\temp\KB2999226' -NoNewWindow
        dism.exe /online /add-package /norestart /quiet /PackagePath:C:\Windows\temp\KB2999226\Windows8.1-KB2999226-x64.cab
    }
}





Switch (Get-OSVersion) {

    'win7' {
        install-KB2999226for2008r2
        BREAK 
    }

    'win8.1' {
        install-KB2999226for2012r2
        BREAK 
    }


    default {
        Get-OSVersion
        BREAK 
    }
}

# dism exit code is 3010 when a reboot is required.
# https://cloudywindows.io/windowsinstallererrorcodes/
exit 0