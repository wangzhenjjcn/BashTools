@echo off
rem FTP服务器地址
set ftpIP= 
rem FTP登入名
set ftpUser= 
rem FTP登入密码
set ftpPass= 
rem 需要下载的FTP目录（默认为整站下载）
set ftpFolder=.
set LocalFolder=%~dp0
rem 生成FTP目录结构
>"%temp%\ftpTree.txt" type nul
start /w /min cmd /c MakeTree.bat "%ftpFolder%" 0
for /f "usebackq delims=/" %%a in ("%temp%\ftpTree.txt") do (
    cd /d "%LocalFolder%"
    md "%%a"
    cd /d "%%a"
    >"%temp%\ftpFile.txt" (
        echo,%ftpUser%
        echo,%ftpPass%
        echo,cd "%%a"
        echo,mget *.*
        echo,bye
    )
    if "%ftpUser%" equ "Anonymous" (
        ftp -i -A -s:"%temp%\ftpFile.txt" %ftpIP%
    ) else (
        ftp -i -s:"%temp%\ftpFile.txt" %ftpIP%
    )
)
del /f /q /a "%temp%\ftp*.txt"