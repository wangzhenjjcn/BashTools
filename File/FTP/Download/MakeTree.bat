@echo off
set /a TreeNum=%2+1
>>"%temp%\ftpTree.txt" echo/%~1
>"%temp%\ftpFile%TreeNum%.txt" (
    echo,%ftpUser%
    echo,%ftpPass%
    echo,cd %1
    echo,dir
    echo,bye
)
if "%ftpUser%" equ "Anonymous" (
    ftp -A -s:"%temp%\ftpFile%TreeNum%.txt" %ftpIP%|find " <DIR>">"%temp%\ftpFldLevel%TreeNum%.txt"
) else (
    ftp -s:"%temp%\ftpFile%TreeNum%.txt" %ftpIP%|find " <DIR>">"%temp%\ftpFldLevel%TreeNum%.txt"
)
for /f "usebackq tokens=2,3*" %%i in ("%temp%\ftpFldLevel%TreeNum%.txt") do (
    start /w /min cmd /c MakeTree.bat "%~1\%%k" %TreeNum%
)