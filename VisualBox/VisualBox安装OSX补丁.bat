@echo off
set /p name=���������������:  
echo ȷ�����������%name%����ȷ��������Y
choice /C YNC 
set /a resault = %errorlevel% 
if %resault% == 1 goto run
if %resault% == 2 goto end
if %resault% == 3 goto finish
goto end
:run
echo ����ִ�У��밴�س�����
pause>nul
cd  C:\Program Files\Oracle\VirtualBox\
echo �Ѿ��л�������Ŀ¼
VBoxManage.exe modifyvm %name% --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff 
echo 1/7  done
VBoxManage setextradata %name% "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3" 
echo 2/7  done
VBoxManage setextradata %name% "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0" 
echo 3/7  done
VBoxManage setextradata %name% "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Mac-F2238BAE" 
echo 4/7  done
VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" 
echo 5/7  done
VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1 
echo 6/7  done
VBoxManage setextradata %name% "VBoxInternal2/EfiGopMode" 4  
echo 7/7  All done!
goto finish
:end
echo �Ѿ�ȡ������
:finish
echo ȷ���޸��������%name%���ֱ�����ȷ����ѡ��ֱ�������
echo 1 �C 640��480 
echo 2 �C 800��600 
echo 3 �C 1024��768 
echo 4 �C 1280��1024 
echo 5 �C 1440��900 
echo 6 �C 1920��1200
echo C �C ȡ��
cd  C:\Program Files\Oracle\VirtualBox\
echo �Ѿ��л�������Ŀ¼
VBoxManage setextradata %name% "CustomVideoMode1 1920x1080x32"
choice /C 123456C
set /a resault = %errorlevel% 
if %resault% == 1   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 0
if %resault% == 2   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1 
if %resault% == 3   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 2 
if %resault% == 4   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 3 
if %resault% == 5   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 4 
if %resault% == 6   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 5  
echo ִ����� �ֱ����Ѿ�����Ϊ
if %resault% == 1   echo 1 �C 640��480 
if %resault% == 2   echo 2 �C 800��600 
if %resault% == 3   echo 3 �C 1024��768 
if %resault% == 4   echo 4 �C 1280��1024 
if %resault% == 5   echo 5 �C 1440��900 
if %resault% == 6   echo 6 �C 1920��1200
echo ������˳�
pause>nul

 