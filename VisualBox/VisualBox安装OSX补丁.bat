@echo off
set /p name=请输入虚拟机名称:  
echo 确认是虚拟机【%name%】吗？确认请输入Y
choice /C YNC 
set /a resault = %errorlevel% 
if %resault% == 1 goto run
if %resault% == 2 goto end
if %resault% == 3 goto finish
goto end
:run
echo 即将执行，请按回车继续
pause>nul
cd  C:\Program Files\Oracle\VirtualBox\
echo 已经切换到工作目录
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
echo 已经取消操作
:finish
echo 确认修改虚拟机【%name%】分辨率吗？确认请选择分辨率输入
echo 1 – 640×480 
echo 2 – 800×600 
echo 3 – 1024×768 
echo 4 – 1280×1024 
echo 5 – 1440×900 
echo 6 – 1920×1200
echo C – 取消
cd  C:\Program Files\Oracle\VirtualBox\
echo 已经切换到工作目录
VBoxManage setextradata %name% "CustomVideoMode1 1920x1080x32"
choice /C 123456C
set /a resault = %errorlevel% 
if %resault% == 1   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 0
if %resault% == 2   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1 
if %resault% == 3   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 2 
if %resault% == 4   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 3 
if %resault% == 5   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 4 
if %resault% == 6   VBoxManage setextradata %name% "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 5  
echo 执行完毕 分辨率已经调整为
if %resault% == 1   echo 1 – 640×480 
if %resault% == 2   echo 2 – 800×600 
if %resault% == 3   echo 3 – 1024×768 
if %resault% == 4   echo 4 – 1280×1024 
if %resault% == 5   echo 5 – 1440×900 
if %resault% == 6   echo 6 – 1920×1200
echo 完成请退出
pause>nul

 