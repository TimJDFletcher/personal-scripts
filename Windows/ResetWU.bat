@echo off
net stop wuauserv
net stop bits
rd /s /q %windir%\softwaredistribution
net start bits
net start wuauserv
wuauclt.exe /detectnow