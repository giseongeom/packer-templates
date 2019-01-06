#Requires -version 5

Function Get-OSVersion {
    [string]$returnValue = ''
    $BuildVersion = [System.Environment]::OSVersion.Version

    if ($BuildVersion.Major -ge '10') {
        #Write-Warning 'WMF 5.1 is not supported for Windows 10 and above.'
        $returnValue = 'win10'
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


Function install-WMF51Fixfor2008r2 {
    # http://blog.buktenica.com/windows-management-framework-breaks-sysprep/
    # https://windowsserver.uservoice.com/forums/301869-powershell/suggestions/11591262-bug-wmf-5-production-preview-on-windows-server-2
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\StreamProvider" -Name LastFullPayloadTime -Value 0 -PropertyType DWord -Force  
}


Switch (Get-OSVersion) {

    'win7' {
        install-WMF51Fixfor2008r2
        BREAK 
    }

    default {
        Get-OSVersion
        BREAK 
    }
}

