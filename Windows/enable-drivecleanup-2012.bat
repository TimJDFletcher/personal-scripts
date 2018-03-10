@echo off
copy %SystemRoot%\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.2.9200.16384_none_c60dddc5e750072a\cleanmgr.exe %systemroot%\System32
copy %SystemRoot%\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.2.9200.16384_en-us_b6a01752226afbb3\cleanmgr.exe.mui %systemroot%\System32\en-US
%systemroot%\System32\cleanmgr.exe 

