$myAccount = (Get-LocalGroupMember -Group Administrators | Where-Object { $_.sid -like "*-500" }).Name
$myUserName = $myAccount -replace "^.*\\",""
Set-LocalUser -Name $myUserName -PasswordNeverExpire $true


# CompleteImage
Set-Location "C:\Program Files\Microsoft SQL Server\130\Setup Bootstrap\SQLServer2016" 
& ./setup.exe /IAcceptSQLServerLicenseTerms /Q /ACTION=CompleteImage `
  /INSTANCENAME="MSSQLSERVER" /INSTANCEID="MSSQLSERVER" `
  /SECURITYMODE=SQL /TCPENABLED=1 /AGTSVCACCOUNT="NT Service\SQLSERVERAGENT" `
  /AGTSVCSTARTUPTYPE="Automatic" /SQLCOLLATION="Latin1_General_CI_AI_KS" `
  /SQLSVCACCOUNT="NT Service\MSSQLSERVER" `
  /SQLSYSADMINACCOUNTS="$myUserName" `
  /SAPWD="$env:SQLPWD"


# Remove SQLPWD credential
& reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V SQLPWD


# Add FirewallRule
New-NetFirewallRule -DisplayName "SQL Server (TCP-in)" `
  -Enabled true -Protocol TCP -LocalPort 1433 -RemoteAddress Any -Action Allow
