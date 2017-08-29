@echo off
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes
net accounts /MAXPWAGE:UNLIMITED
wmic useraccount WHERE "Name='Administrator'" set PasswordExpires=false

