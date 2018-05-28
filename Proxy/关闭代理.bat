@echo off 

echo 开始设置取消xproxy代理..........

echo 现在程序将关闭您的浏览器。。。。。
echo 继续请按回车，如果不想关闭浏览器请直接关闭此程序或者按 ctrl+c 退出程序！
pause;
taskkill /f /im iexplore.exe
taskkill /f /im chrome.exe
taskkill /f /im SougouExplorer.exe
taskkill /f /im 360Chrome.exe
taskkill /f /im QQBrowser.exe
taskkill /f /im iexplore.exe
taskkill /f /im chrome.exe
taskkill /f /im SougouExplorer.exe
taskkill /f /im 360Chrome.exe
taskkill /f /im QQBrowser.exe

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "" /f 
ipconfig /flushdns
color 2
echo 已取消代理服务器上网
echo 按任意键关闭此对话框
pause>nul