@echo off
REM ----------------------------------------------------------------------------------------
REM 演示：删除指定路径下指定天数之前（以文件夹的最后修改日期为准）的文件夹。
REM 如果演示结果无误，把rd前面的echo去掉，即可实现真正删除。
REM 本例调用了临时VBS代码进行日期计算，并统一设置系统日期格式，处理完毕
REM 之后再把日期格式恢复成原来的状态。摆脱了对reg命令（XP系统自带）的依赖。
REM ----------------------------------------------------------------------------------------

REM 指定待删除文件夹的存放路径
set SrcDir=C:\test
REM 指定天数
set DaysAgo=1
>"%temp%\BackupDate.vbs" echo Set WshShell = WScript.CreateObject("WScript.Shell")
>>"%temp%\BackupDate.vbs" echo WScript.Echo WshShell.RegRead ("HKEY_CURRENT_USER\Control Panel\International\sShortDate")
for /f %%a in ('cscript /nologo "%temp%\BackupDate.vbs"') do (
    set "RegDateOld=%%a"
)
>"%temp%\UnifyDate.vbs" echo Set WshShell = WScript.CreateObject("WScript.Shell")
>>"%temp%\UnifyDate.vbs" echo WshShell.RegWrite "HKEY_CURRENT_USER\Control Panel\International\sShortDate", "yyyy-M-d", "REG_SZ"
cscript /nologo "%temp%\UnifyDate.vbs"
>"%temp%\DstDate.vbs" echo LastDate=date()-%DaysAgo%
>>"%temp%\DstDate.vbs" echo FmtDate=right(year(LastDate),4) ^& right("0" ^& month(LastDate),2) ^& right("0" ^& day(LastDate),2)
>>"%temp%\DstDate.vbs" echo wscript.echo FmtDate
for /f %%a in ('cscript /nologo "%temp%\DstDate.vbs"') do (
    set "DstDate=%%a"
)
set DstDate=%DstDate:~0,4%-%DstDate:~4,2%-%DstDate:~6,2%
for /d %%a in ("%SrcDir%\*.*") do (
    if "%%~ta" leq "%DstDate%" (
        if exist "%%a\" (
            echo rd /s /q "%%a"
        )
    )
)
>"%temp%\RecoverDate.vbs" echo Set WshShell = WScript.CreateObject("WScript.Shell")
>>"%temp%\RecoverDate.vbs" echo WshShell.RegWrite "HKEY_CURRENT_USER\Control Panel\International\sShortDate", "%RegDateOld%", "REG_SZ"
cscript /nologo "%temp%\RecoverDate.vbs"
pause