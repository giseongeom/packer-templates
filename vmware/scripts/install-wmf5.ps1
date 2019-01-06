
Function Get-OSVersion {
    [string]$returnValue = ''
    $BuildVersion = [System.Environment]::OSVersion.Version

    if ($BuildVersion.Major -ge '10') {
        #Write-Warning 'WMF 5.1 is not supported for Windows 10 and above.'
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
        #Write-Warning "WMF 5.1 is not supported on BuildVersion: {0}" -f $BuildVersion.ToString()
        $returnValue = 'vista'
    }

    ## OS is below Windows Vista
    if ($BuildVersion.Major -lt '6') {
        #Write-Warning "WMF 5.1 is not supported on BuildVersion: {0}" -f $BuildVersion.ToString()
        $returnValue = 'xp'
    }
    return $returnValue
}


Function install-WMF51for2012r2 {
    $wmf51_file_url = 'http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu'
    $wmf51_root     = 'C:\Windows\temp\wmf51'
    $wmf51_file     = 'c:\Windows\temp\wmf51\Win8.1AndW2K12R2-KB3191564-x64.msu'
    mkdir -Force -ErrorAction SilentlyContinue $wmf51_root
    (New-Object Net.WebClient).DownloadFile($wmf51_file_url, $wmf51_file) 

    If (Test-path $wmf51_file) {
        Start-Process -wait wusa.exe -ArgumentList 'c:\windows\temp\wmf51\Win8.1AndW2K12R2-KB3191564-x64.msu /extract:c:\windows\temp\wmf51\src'
        dism.exe /online /add-package /norestart /quiet /PackagePath:c:\windows\temp\wmf51\src\WindowsBlue-KB3191564-x64.cab
    }
}


Function install-WMF51for2008r2 {
    $wmf51_file_url = 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip'
    $wmf51_zipfile  = 'C:\Windows\temp\wmf51-installer.zip' 
    $wmf51_root     = 'C:\Windows\temp\wmf51'
    (New-Object Net.WebClient).DownloadFile($wmf51_file_url, $wmf51_zipfile) 

    If (Test-Path $wmf51_zipfile) {
        unzip.exe $wmf51_zipfile -d $wmf51_root

        If (Test-Path $wmf51_root\Win7AndW2K8R2-KB3191566-x64.msu) {
            Start-Process -wait wusa.exe -ArgumentList 'c:\windows\temp\wmf51\Win7AndW2K8R2-KB3191566-x64.msu /extract:c:\windows\temp\wmf51\src'
            dism.exe /online /add-package /norestart /quiet /PackagePath:c:\windows\temp\wmf51\src\Windows6.1-KB3191566-x64.cab
        }
    }
}




Switch (Get-OSVersion) {

    'win7' {
        install-WMF51for2008r2
        BREAK 
    }

    'win8.1' {
        install-WMF51for2012r2
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