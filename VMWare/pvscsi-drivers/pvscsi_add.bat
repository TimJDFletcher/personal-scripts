@echo off

echo "Inject PVSCSI drivers ? (CTRL-C to exit)"
pause

if exist "Drivers\pvscsi" goto :folderexist
echo "Error drivers not found"
pause
exit

:folderexist
reg import pvscsi.reg

echo Detecting OS processor type

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto 64BIT
echo 32-bit OS
copy "Drivers\pvscsi\i386\pvscsi.sys" "%windir%\system32\drivers\pvscsi.sys"
copy "Drivers\pvscsi\i386\pvscsi.inf" "%windir%\inf\pvscsi.inf"
goto END

:64BIT
echo 64-bit OS
copy "Drivers\pvscsi\amd64\pvscsi.sys" "%windir%\system32\drivers\pvscsi.sys"
copy "Drivers\pvscsi\amd64\pvscsi.inf" "%windir%\inf\pvscsi.inf"
:END

