@echo off 

echo ��ʼ����ȡ��xproxy����..........

echo ���ڳ��򽫹ر��������������������
echo �����밴�س����������ر��������ֱ�ӹرմ˳�����߰� ctrl+c �˳�����
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
echo ��ȡ���������������
echo ��������رմ˶Ի���
pause>nul