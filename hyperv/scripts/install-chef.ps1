#
. { iwr -useb https://omnitruck.chef.io/install.ps1 } | Invoke-Expression; install -channel stable -project chef