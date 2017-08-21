winrm set winrm/config/service/auth @{Basic="true"}
winrm set winrm/config/service @{AllowUnencrypted="true"}

Set-LocalUser -Name Administrator -PasswordNeverExpire $true
Set-LocalUser -Name vagrant       -PasswordNeverExpire $true