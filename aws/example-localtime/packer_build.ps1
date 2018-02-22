#Requires -Version 5

# GET-DATE format YYYY.MM.DD-HHMM
$env:_MY_AWS_BUILD_DATE_LOCALTIME=""
$env:_MY_AWS_BUILD_DATE_LOCALTIME=(get-date -UFormat %Y.%m.%d-%H%M)

& packer.exe $args
