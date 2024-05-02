@echo off
chcp 65001
echo 如果您不介意失去一些 Windows 功能，您可以卸载 Windows 备份。
echo If you do not care about losing some Windows features, you can uninstall Windows Backup.

REM Check if running with administrative privileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    goto :runScript
) else (
    echo This script requires administrative privileges to uninstall Windows Backup.
    echo 请右键点击此脚本，并选择“以管理员身份运行”。
    echo Please right-click this script and select "Run as administrator".
    pause
    exit /b
)

:runScript
REM Confirm user action
set /p choice=Are you sure you want to uninstall Windows Backup? (y/n): 
if /i "%choice%"=="y" (
    goto :uninstallBackup
) else if /i "%choice%"=="n" (
    echo Operation cancelled.
    pause
    exit /b
) else (
    echo Invalid choice. Please enter y for Yes or n for No.
    goto :runScript
)

:uninstallBackup
echo Uninstalling Windows Backup...
PowerShell -Command "Remove-WindowsPackage -Online -PackageName 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4123'"
echo Please reboot your system to complete the uninstallation.
pause
exit /b
