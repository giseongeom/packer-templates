$SMB1state = (Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol).State
if ($SMB1state -ne 'Disabled') {
  Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -Verbose
}