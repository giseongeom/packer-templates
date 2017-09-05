# cd to ISO-Mounted Drive
$ISOMOUNT = Mount-DiskImage -ImagePath C:\Windows\Temp\sql.iso -PassThru
$SQLDRV = ($ISOMOUNT | Get-Volume).DriveLetter + ':'
Set-Location $SQLDRV

# PrepareImage
& ./setup.exe /IAcceptSQLServerLicenseTerms /Q /ACTION=PrepareImage `
  /FEATURES=SQLENGINE,REPLICATION,FULLTEXT,IS,CONN `
  /ENU="True" `
  /UpdateEnabled="False" `
  /INSTANCEID="MSSQLSERVER"
