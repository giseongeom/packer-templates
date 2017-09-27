(gcim win32_service | ? { $_.name -match "WindowsAzureGuestAgent" }).PathName
get-service WindowsAzureGuestAgent | ft -autosize
