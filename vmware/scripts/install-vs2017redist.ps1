# https://kb.vmware.com/s/article/55798
# To resolve installation requirement of VMware Tools 10.3.x for windows 
$vs2017_redist_x64_url  = 'http://download.visualstudio.microsoft.com/download/pr/9fbed7c7-7012-4cc0-a0a3-a541f51981b5/e7eec15278b4473e26d7e32cef53a34c/vc_redist.x64.exe'
$vs2017_redist_x64_path = 'c:\windows\temp\VS2017_VC_redist_x64.exe'
(New-Object Net.WebClient).DownloadFile($vs2017_redist_x64_url, $vs2017_redist_x64_path) 

$vs2017_redist_x86_url = 'http://download.visualstudio.microsoft.com/download/pr/d0b808a8-aa78-4250-8e54-49b8c23f7328/9c5e6532055786367ee61aafb3313c95/vc_redist.x86.exe'
$vs2017_redist_x86_path = 'c:\windows\temp\VS2017_VC_redist_x86.exe'
(New-Object Net.WebClient).DownloadFile($vs2017_redist_x86_url, $vs2017_redist_x86_path) 

IF (Test-Path $vs2017_redist_x64_path) {
    Start-process -Wait -Verbose -FilePath $vs2017_redist_x64_path -ArgumentList '/install /quiet /norestart' -NoNewWindow
}

IF (Test-Path $vs2017_redist_x86_path) {
    Start-process -Wait -Verbose -FilePath $vs2017_redist_x86_path -ArgumentList '/install /quiet /norestart' -NoNewWindow
}

# To avoid unexpected $LASTEXITCODE other than 0 (zero)
exit 0