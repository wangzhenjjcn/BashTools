@echo off&title ���ļ�������
echo please wait...
for /f "skip=1" %%i in ('wmic logicaldisk where "drivetype=3" get caption') do (cd /d %%i\&&call :L)
echo                 ---%time%--- 1>>%tmp%\m
type %tmp%\m
del %tmp%\m
echo �������...
pause>nul&exit/b
:L
dir /b/ad/s 1>q
del  t 2>nul
for /f "delims=" %%i in (q) do (rd "%%i" 2>nul&&echo %%i 1>t&&echo %%i 1>>%tmp%\m)
if exist t (goto L)
del  q