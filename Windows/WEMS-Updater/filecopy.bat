@echo off
rem WEMS serial driver update script, written by Tim Fletcher

rem Sets the location of putty, use "set puttydir=%Programfiles(x86)%\putty" to use a local version
rem Latest version of plink can be found here: http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe
set puttydir="%~dp0"

rem Sets the location of the new files directory to the same as the script, use "set filedir=c:\path\to\files" to use a different version
rem Driver location on WEMS internal network: http://192.168.1.10/serial/aserial_test.ko
set sourcedir="%~dp0"

rem Set the name of the module we are copying
set module=aserial_test.ko
rem Set the name of the agent we are copying
set agent=awd_agent
rem Set the name of the initscript we are copying
set initscript=persistAwd

rem Set the destination directory on the programmer for the new module
set moddir=/mnt/lib/modules/3.7.10wems+
rem Set the destination directory for the agent
set agentdir=/mnt/bin
rem Set the destination directory for the init script
set initdir=/mnt/etc/init.d
rem Copy a backup of the files to here too, in case of upgrades
set backup=awd_agentV2

rem Prompts for the target IP
SET /P programmer="Enter programmer IP: "
rem Credentials for the programmer
set user=root
set password=glasshouse

FOR /F "tokens=* USEBACKQ" %%F IN (`"%puttydir%"\plink.exe -pw %password% %user%@%programmer% cat /etc/config/device`) DO (
SET DEVICE=%%F
)

IF NOT %DEVICE% == ASD01V5 GOTO WRONGDEVICE
echo Found a ASD01V5 system updating %agent% and %module%

rem Rename the original files with a _bak on the end, also fixes upgrading running binary
%puttydir%\plink.exe -pw %password% %user%@%programmer% mv "%moddir%/%module%" "%moddir%/%module%_bak"
%puttydir%\plink.exe -pw %password% %user%@%programmer% mv "%agentdir%/%agent%" "%agentdir%/%agent%_bak"

rem This copies the new module over, using type, ssh and dd to work round broken sftp
:DO_COPY
type %sourcedir%\%module%      | %puttydir%\plink.exe -pw %password% %user%@%programmer% dd of=%moddir%/%module%      || goto COPYFAILED
type %sourcedir%\%agent%       | %puttydir%\plink.exe -pw %password% %user%@%programmer% dd of=%agentdir%/%agent%     || goto COPYFAILED
type %sourcedir%\%initscript%  | %puttydir%\plink.exe -pw %password% %user%@%programmer% dd of=%initdir%/%initscript% || goto COPYFAILED

rem Set permissions on the module and agent
%puttydir%\plink.exe -pw %password% %user%@%programmer% chmod 664 "%moddir%/%module%"
%puttydir%\plink.exe -pw %password% %user%@%programmer% chmod 755 "%agentdir%/%agent%"
%puttydir%\plink.exe -pw %password% %user%@%programmer% chmod 755 "%initdir%/%initscript%"

rem Print the MD5 sum of the remote and local checksums
%puttydir%\plink.exe -pw %password% %user%@%programmer% md5sum "%moddir%/%module%"
type %sourcedir%\%module%.md5
%puttydir%\plink.exe -pw %password% %user%@%programmer% md5sum "%agentdir%/%agent%"
type %sourcedir%\%agent%.md5
%puttydir%\plink.exe -pw %password% %user%@%programmer% md5sum "%initdir%/%initscript%"
type %sourcedir%\%initscript%.md5

rem echo Placing init script and binary backup 
%puttydir%\plink.exe -pw %password% %user%@%programmer% ln -fs ../../init.d/persistAwd /mnt/etc/rc.d/rcS.d/S33persistAwd 
%puttydir%\plink.exe -pw %password% %user%@%programmer% cp -a "%agentdir%/%agent%" "%agentdir%/%backup%"
GOTO REBOOT

:REBOOT
echo Would you like to reboot the programmer?(Y/N)
set INPUT=
set /P INPUT=Type input: %=%
If /I "%INPUT%"=="y" goto do_reboot
If /I "%INPUT%"=="n" goto exit
echo Enter Y or N only & goto reboot

:DO_REBOOT
echo Rebooting programmer
%puttydir%\plink.exe -pw %password% %user%@%programmer% "sync ; reboot"
GOTO EXIT

:COPYFAILED
echo Failed to copy files to %programmer%, would you like to retry?(Y/N)
set INPUT=
set /P INPUT=Type input: %=%
If /I "%INPUT%"=="y" goto DO_COPY
If /I "%INPUT%"=="n" goto exit
echo Enter Y or N only & goto copyfailed

:WRONGDEVICE
echo Programmer %programmer% is a %DEVICE% system not a ASD01V5 system, bailing out
GOTO EXIT

:EXIT
pause & exit
