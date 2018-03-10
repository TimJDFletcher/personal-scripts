@echo off
%SYSTEMDRIVE%
cd %WINDIR%\system32\sysprep
sysprep /generalize /oobe /shutdown /unattend:%~dp0unattend.xml
