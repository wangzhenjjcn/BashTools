@echo off
call :Inspect
title 获取硬件信息 - 正在获取相关信息，请稍等...
call :Net
Setlocal EnableDelayedExpansion
echo !Tit!
echo .............................................................
echo.
if not exist "%Temp%\DxDiag.txt" DxDiag /t %Temp%\DxDiag.txt
:DxDiag
if exist "%Temp%\DxDiag.txt" (
	Attrib +h %Temp%\DxDiag.txt
	Ping 127.1 >nul
	for /f "tokens=2 delims=:" %%i in (%Temp%\DxDiag.txt) do (
		set /a N.1+=1
		if !N.1! Equ 3 (
			for /f "delims=(" %%j in ("%%i") do set OS=%%j
	)	)
) else (ping 127.1 >nul
	goto :DxDiag
)
title 获取硬件信息 - %OS%

for /f "tokens=2 delims=:" %%i in (%Temp%\DxDiag.txt) do (
	set /a N.2+=1
	if !N.2! Equ 8 (for /f "delims=," %%j in ("%%i") do set CPU=%%j))
echo.CPU  .......%CPU%
echo.

for /f "tokens=2 delims==" %%i in ('Wmic Baseboard Get Manufacturer /Value') do set Manufacturer=%%i
for /f "tokens=2 delims==" %%i in ('Wmic Baseboard Get Product /Value') do set Product=%%i
echo.主板 ....... %Manufacturer%   (%Product%)
echo.

for /f %%i in ('Wmic Path Win32_PhysicalMemory Get BankLabel^|find /i /c "Bank"') do set N.3=%%i
set /a N.3-=1
set Size.1=0
for /f "skip=1 delims=" %%i in ('Wmic Path Win32_PhysicalMemory Get Capacity') do (	
	set Memory=%%i
	call :Addition !Memory! !Size.1! Size.1 
)
call :GetSize !Size.1! Size.1
if "!Size.1:~-5,3!"==".00" set Size.1=!Size.1:~0,-5! !Size.1:~-2!
echo.内存 ....... %N.3% 条   %Size.1%
echo.

for /f "tokens=2 delims==" %%i in ('Wmic DiskDrive Get Model /Value^|find /i /v "USB"') do (
	set /a N.4+=1
	if !N.4! Equ 1 set FirstDisk=%%i
)
echo.硬盘 ....... %N.4% 块   %FirstDisk% (主)
echo.

for /f "tokens=2 delims==" %%i in ('Wmic Path Win32_VideoController Get Name^,AdapterRam^,AdapterCompatibility^,DriverDate^,DriverVersion^,VideoProcessor 

/Value') do (
	set /a N.5+=1
	if !N.5! == 1 set AdapterCompatibility=%%i
	if !N.5! == 2 set AdapterRam=%%i
	if !N.5! == 3 set DriverDate=%%i
	if !N.5! == 4 set DriverVersion=%%i
	if !N.5! == 5 set Name=%%i
	if !N.5! == 6 set VideoProcessor=%%i
)
if "%AdapterRam%"=="" (set AdapterRam=无法获取显存) else (
		call :GetSize %AdapterRam% AdapterRam
		if "!AdapterRam:~-5,3!"==".00" set AdapterRam=!AdapterRam:~0,-5! !AdapterRam:~-2!
)
set DriverDate=%DriverDate:~0,4% 年 %DriverDate:~4,2% 月 %DriverDate:~6,2% 日
if "!AdapterRam!"=="无法获取显存" (echo.显卡 ....... %Name%) else (echo.显卡 ....... %Name%  %AdapterRam% 显存)
echo.

for /f "tokens=2 delims==" %%i in ('Wmic DesktopMonitor Get PNPDeviceID /Value') do (		
	for /f "delims=\ tokens=2" %%j in ("%%i") do set DisplayName=%%j
)
for /f "tokens=2 delims=:" %%i in ('find /i "current mode" %Temp%\DxDiag.txt') do set Resolution=%%i
if "%DisplayName%"=="" (echo.屏幕 .......!Resolution!) else (echo.屏幕 ....... !DisplayName! !Resolution!)
echo.

for /f "delims== tokens=2" %%i in ('Wmic Path Win32_CDRomDrive Get Name /Value 2^>nul') do (
	set /a N.6+=1
	if !N.6! Equ 1  set CD-ROM.1=%%i
	if !N.6! Equ 2  set CD-ROM.2=; %%i
)
if "%CD-ROM.1%"=="" set CD-ROM.1=无
echo.光驱 ....... %CD-ROM.1% %CD-ROM.2%
echo.

for /f "tokens=2 delims==" %%i in ('Wmic Sounddev Get ProductName /Value 2^>nul') do (
	set /a N.7+=1
	if !N.7! Equ 1  set Sound.1=%%i
	if !N.7! Equ 2  set Sound.2=; %%i
)
if "%Sound.1%"=="" set Sound.1=没有发现声卡 可能已被卸载
echo 声卡 ....... %Sound.1% %Sound.2%
echo.

echo 网卡 ....... %NetName% (%NetWorking%)
echo.
echo.
Rem wangzhenjjcn
set /p wangzhenjjcn=若要生成详细的电脑配置信息文件请直接回车：
if "!wangzhenjjcn!"=="1" Goto :CpuTest
:Star
Title 获取硬件信息 - 正在生成详细信息，请稍等...
if "!Titl!" neq "检测环境处于虚拟机中，以下信息可能不准：" Color 08
set Tim.1=%Time%
set File=%ComputerName%.Txt
echo %Titl%>!File!
echo ............................................................. >>!File!
echo.>>!File!
echo.关于 CPU 的详细信息如下：>>!File!
echo.>>!File!
echo.    名称 ........... :%CPU%>>!File!
echo.>>!File!

set NumberOfProcessors=-1
for /f "tokens=2 delims==" %%i in ('wmic path Win32_PerfFormattedData_PerfOS_Processor get PercentProcessorTime /Value 2^>NUL') do set /a 

NumberOfProcessors+=1
if "!NumberOfProcessors!" equ "-1" (
	for /f "delims== tokens=2" %%i in ('Wmic ComputerSystem Get NumberOfProcessors /Value') do set NumberOfProcessors=%%i
)
echo.    核心 ........... : %NumberOfProcessors% 核心>>!File!
echo.>>!File!
if "!Score!" Neq "" (echo.    跑分 ........... : !Score! 分>>!File!
		     echo.>>!File!)
for /f "delims== tokens=2" %%i in ('Wmic CPU Get CurrentClockSpeed /Value') do set CurrentClockSpeed=%%i
echo.    主频 ........... : %CurrentClockSpeed% Mhz>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic CPU Get ExtClock /Value') do set ExtClock=%%i
echo.    外频 ........... : %ExtClock% Mhz>>!File!
echo.>>!File!
for /f "Skip=1" %%i in ('Wmic Path Win32_CacheMemory Get MaxCacheSize') do (
	set /a N.8+=1
	if !N.8! Equ 1 set /a One=%%i
	if !N.8! Equ 2 set /a Two=%%i
	if !N.8! Equ 3 set /a Three=%%i
)
if /i !One! Equ 0 set One=0
if /i !Two! Equ 0 set Two=0
if /i !Three! Equ 0 set Three=0
echo.    一级缓存 ....... : %One% KB>>!File!
echo.>>!File!
echo.    二级缓存 ....... : %Two% KB>>!File!
echo.>>!File!
echo.    三级缓存 ....... : %Three% KB>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic CPU Get SocketDesignation /Value') do set SocketDesignation=%%i
echo.    插槽 ........... : %SocketDesignation%>>!File!
echo.>>!File!
for /f "delims== tokens=2*" %%i in ('Wmic CPU Get ProcessorID /Value') do set ProcessorID=%%i
echo.    编号 ........... : %ProcessorID%>>!File!
echo.>>!File!
echo.>>!File!
echo.关于主板的详细信息如下：>>!File!
echo.>>!File!
echo.    品牌 ........... : %Manufacturer%>>!File!
echo.>>!File!
echo.    型号 ........... : %Product%>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic Baseboard Get SerialNumber /Value') do set SerialNumber=%%i
echo.    编号 ........... : %SerialNumber%>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic Baseboard Get Version /Value') do set Version=%%i
echo.    版本 ........... : %Version%>>!File!
echo.>>!File!
for /f "tokens=2 delims==" %%i in ('Wmic Memphysical Get MaxCapacity /Value') do set MaxCapacity=%%i
set /a MaxCapacity/=1048576
echo.    内存支持 ....... : %MaxCapacity% GB>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic bios Get ReleaseDate /Value') do set ReleaseDate=%%i
set ReleaseDate=%ReleaseDate:~0,4% 年 %ReleaseDate:~4,2% 月 %ReleaseDate:~6,2% 日
echo.    出厂日期 ....... : %ReleaseDate%>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic bios Get SmbiosbioSversion /Value') do set SmbiosbioSversion=%%i
echo.    BIOS 版本 ...... : %SmbiosbioSversion%>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic bios Get InstallableLanguages /Value') do set InstallableLanguages=%%i
if %InstallableLanguages% Equ 1 (set InstallableLanguages=英文界面) else set InstallableLanguages=!InstallableLanguages! 国语言
echo.    BIOS 语言 ...... : %InstallableLanguages%>>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic bios Get Manufacturer /Value') do set Manufacturer=%%i
echo.    BIOS 制造商 .... : %Manufacturer%>>!File!
echo.>>!File!
echo.>>!File!
echo.关于内存的详细信息如下：>>!File!
echo.>>!File!
echo.    数量 ........... : %N.3% 条>>!File!
echo.>>!File!
echo.    总容量 ......... : %Size.1%>>!File!
echo.>>!File!
echo.>>!File!
echo.    内存     容量         频率      插槽>>!File!
echo.>>!File!
for /f "skip=1 delims=" %%i in ('Wmic Path Win32_PhysicalMemory Get DeviceLocator^,Capacity^,Speed') do (
	set /a N.9+=1 
	set Var.i=%%i
	for /f "tokens=1,2,3" %%j in ("!Var.i!") do (
		set Var.j=%%j
		set Var.k=%%k
		set Var.l=%%l
	)
	if "!Var.l!"=="" set Var.l=NotGet
	call :GetSize !Var.j! Var.jj
	call ::Space !Var.l!  10 S.1
	call ::Space !Var.jj! 13 S.2
if not "!Var.i:~1,1!"== "" echo.    !N.9!        !Var.jj!!S.2!!Var.l!!S.1!!Var.k!>>!File!
)
echo.>>!File!
echo.>>!File!
for /f "tokens=2 delims==" %%i in ('wmic path Win32_PerfFormattedData_PerfOS_Memory get AvailableBytes /Value 2^>NUL') do set Available=%%i
if "!Available!" neq "" call :GetSize !Available! Available
for /f "tokens=2 delims==" %%i in ('wmic path Win32_PerfFormattedData_PerfOS_Memory get CommittedBytes /Value 2^>NUL') do set Committed=%%i
if "!Committed!" neq "" call :GetSize !Committed! Committed
for /f "tokens=2 delims==" %%i in ('wmic path Win32_PerfFormattedData_PerfOS_Memory get CommitLimit /Value 2^>NUL') do set CommitLimit=%%i
if "!CommitLimit!" neq "" call :GetSize !CommitLimit! CommitLimit
if "!Available!" neq "" (
	echo.    已用内存 : %Committed%    可用内存 : %Available%    提交限制 : %CommitLimit%>>!File!
	echo.>>!File!
	echo.>>!File!
)
echo.关于硬盘的详细信息如下：>>!File!
echo.>>!File!
echo.    数量 ........... : %N.4% 块>>!File!
echo.>>!File!
set Size.2=0
for /f "skip=1 delims=" %%i in ('Wmic DiskDrive Get Size') do (
	set Var.i=%%i
	call :Addition !Var.i! !Size.2! Size.2
)
call :GetSize !Size.2! Size.2
if "!Size.2:~-5,3!"==".00" set Size.2=!Size.2:~0,-5! !Size.2:~-2!
echo.    总容量 ............... : !Size.2!>>!File!
echo.>>!File!

if "!Tit!"=="检测环境处于虚拟机中，以下信息可能不准：" goto :Go
for /f "tokens=2 delims==" %%i in ('Wmic /NameSpace:\\root\wmi Path MSStorageDriver_ATAPISmartData get VendorSpecific /Value 2^>Nul') do (
	set /a DiskNuber+=1
	set Smart=%%i
	set Smart=!Smart:,= !
	for /l %%j in (3 12 362) do (
		set Nu.1=0
		for %%k in (!Smart!) do (
			set /a Nu.1+=1
			if !Nu.1! Equ %%j (
				if %%k Equ 9 (set /a Nu.2=!Nu.1!+7
					      call :Calc !Nu.1! !Nu.2! PowerOnTimeCount)
				if %%k Equ 12 (set /a Nu.2=!Nu.1!+7
					       call :Calc !Nu.1! !Nu.2! StartStopCount)
				set /a Nu.3=0,Nu.4=0
				if %%k Equ 190 (set /a Nu.3=!Nu.1!+5
					for %%l in (!Smart!) do (
						set /a Nu.4+=1
						if !Nu.4! Equ !Nu.3! set Temperature=%%l
						)	
				) else (
					if %%k Equ 194 (set /a Nu.3=!Nu.1!+5
						for %%l in (!Smart!) do (
							set /a Nu.4+=1
							if !Nu.4! Equ !Nu.3! set Temperature=%%l
						)
					)
				)
			)
		)
	)		
set /a Day=!PowerOnTimeCount!/24
echo.>>!File!
echo     硬盘 !DiskNuber!: >>!File!
echo.>>!File!
echo     当前硬盘温度 ..................... : !Temperature! ℃>>!File!
echo.>>!File!
echo     截至目前硬盘已启停：..................... : !StartStopCount! 次>>!File!
echo.>>!File!
echo     截至目前硬盘已累计运行 ..................... : !PowerOnTimeCount! 小时（!Day!天）>>!File!
)
echo.>>!File!
:Go
echo.>>!File!
echo.    硬盘    分区     模式        容量        状态        型号>>!File!
echo.>>!File!
for /f "skip=1 delims=" %%i in ('Wmic DiskDrive Get Partitions^,InterFacetype^,Size^|find /i /v "USB"') do (
	set /a Num.1+=1
	set Var.i=%%i
	for /f "tokens=1,2,3" %%j in ("!Var.i!") do (
		set Var.j=%%j
		set Var.k=%%k
		set Var.l=%%l
	)
	set Num.2=0
	for /f "skip=1 delims=" %%m in ('Wmic DiskDrive Get Caption^|find /i /v "USB"') do (
		set /a Num.2+=1
		if !Num.2! Equ !Num.1! set Var.m=%%m
	)
	set Var.mm=
	for %%n in (!Var.m!) do set Var.mm=!Var.mm!%%n 
	if !Num.1! Equ 1 (set Var.n=主盘) else (set Var.n=从盘)
	call :GetSize !Var.l! Var.ll
	call :Space !Num.1!  8 S.0
	call :Space !Var.k!  9 S.1
	call :Space !Var.j!  12 S.2
	call :Space !Var.ll! 12 S.3
if not "!Var.i:~1,1!"=="" echo.    !Num.1!!S.0!!Var.k!!S.1!!Var.j!!S.2!!Var.ll!!S.3!!Var.n!        !Var.m!>>!File!
)
echo.>>!File!
echo.>>!File!
echo.    盘符    格式     容量        已用        剩余        卷标>>!File!
echo.>>!File!
for /f "skip=1 delims=" %%i in ('Wmic LogicalDisk Where Mediatype^='12' Get DeviceID^,FileSystem^,Size^,FreeSpace^,VolumeName') do (
	set Var.i=%%i
	for /f "tokens=1,2,3,4,*" %%j in ("!Var.i!") do (
		set Var.j=%%j
		set Var.k=%%k
		set Var.l=%%l
		set Var.m=%%m
		set Var.n=%%n
		if "!Var.n!"=="" set Var.n=默认值
	)
	call :Minus !Var.m! !Var.l! Var.o
	call :GetSize !Var.l! Var.ll
	call :GetSize !Var.m! Var.mm
	call :GetSize !Var.o! Var.oo
	if "!Var.ll:~-5,3!"==".00" set Var.ll=!Var.ll:~0,-5!!Var.ll:~-2!
	if "!Var.mm:~-5,3!"==".00" set Var.mm=!Var.mm:~0,-5!!Var.mm:~-2!
	if "!Var.oo:~-5,3!"==".00" set Var.oo=!Var.oo:~0,-5!!Var.oo:~-2!
	call :Space !Var.k!   9 S.1
	call :Space !Var.mm! 12 S.2
	call :Space !Var.oo! 12 S.3
	call :Space !Var.ll! 12 S.4
if not "!Var.i:~3,1!"=="" echo.    !Var.j!      !Var.k!!S.1!!Var.mm!!S.2!!Var.oo!!S.3!!Var.ll!!S.4!!Var.n!>>!File!
)
echo.>>!File!
echo.>>!File!

echo.关于显卡的详细信息如下：>>!File!
echo.>>!File!
echo.    名称 ........... : %Name%>>!File!
echo.>>!File!
echo.    制造商 ......... : %AdapterCompatibility%>>!File!
echo.>>!File!
if "%VideoProcessor%"=="" set VideoProcessor=无法获取芯片信息
echo.    芯片类型 ....... : %VideoProcessor%>>!File!
echo.>>!File!
echo.    显存 ........... : %adapterram%>>!File!
echo.>>!File!
echo.    当前模式 ....... :%Resolution%>>!File!
echo.>>!File!
echo.    驱动版本 ....... : %DriverVersion%>>!File!
echo.>>!File!
echo.    驱动日期 ....... : %DriverDate%>>!File!
echo.>>!File!
echo.>>!File!
echo.关于显示器的详细信息如下：>>!File!
echo.>>!File!
if "%DisplayName%" == "" set DisplayName=未能获取显示器名称
echo.    名称 ........... : %DisplayName% >>!File!
echo.>>!File!
echo.    当前模式 ....... :%Resolution%>>!File!
for /f "tokens=2 delims==" %%i in ('Wmic DesktopMonitor Get Description /Value') do set Displaydescription=%%i
echo.>>!File!
echo.    类型 ........... : %Displaydescription%>>!File!

if not "%CD-ROM.1%"=="无" (
echo.>>!File!
echo.>>!File!
echo.关于光驱的详细信息如下：>>!File!
echo.>>!File!
echo.  列出所有光驱: >>!File!
echo.>>!File!
echo.    盘符   类型       型号 >>!File!
echo.>>!File!
for /f  "skip=1 delims=" %%i in ('Wmic CdRom Get Name^,Drive^,Mediatype') do echo.    %%i>>!File!
)
if not "%Sound.1%"=="没有发现声卡 可能已被卸载" (
echo.>>!File!
echo.>>!File!
echo.关于声卡的详细信息如下：>>!File!
echo.>>!File!
echo.  列出所有声卡: >>!File!
echo.>>!File!
for /f "delims== tokens=2" %%i in ('Wmic Sounddev Get ProductName /Value') do (
	set /a N.10+=1
	echo.    !N.10!.  %%i>>!File!
)
echo.>>!File!
echo.  当前声卡信息: >>!File!
echo.>>!File!
for /f "tokens=2 delims=:" %%i in ('find /i "Description" %Temp%\DxDiag.txt') do (
	set /a N.11+=1
	if !N.11! Equ 2 set Description=%%i
)
for /f "tokens=2 delims=:" %%i in ('find /i "Driver Version" %Temp%\DxDiag.txt') do (
	set /a N.12+=1
	if !N.12! Equ 3 set SoundDriverVersion=%%i
)
for /f "tokens=1,* delims=:" %%i in ('find /i "Date and Size" %Temp%\DxDiag.txt') do (
	for /f "tokens=1,2 delims=," %%k in ("%%j") do (
		set SoundDate=%%k
		set SoundSize=%%l
	))
for /f %%i in ("!SoundSize!") do call :GetSize %%i SoundSize
for /f %%i in ("!SoundDate!") do set SoundDate=%%i

for /f "tokens=1,2,3 delims=/" %%i in ("!SoundDate!") do set SoundDate=%%k 年 %%j 月 %%i 日
if "!description!"==" " (
	set Description= 无法获取 声卡已被禁用
	set SoundDriverVersion= 无法获取 声卡已被禁用
	set SoundDate=无法获取 声卡已被禁用
	set SoundSize=无法获取 声卡已被禁用
)
echo.    输出声卡 ....... :!Description!>>!File!
echo.>>!File!
echo.    驱动版本 ....... :!SoundDriverVersion!>>!File!
echo.>>!File!
echo.    驱动日期 ....... : !SoundDate!>>!File!
echo.>>!File!
echo.    驱动大小 ....... : !SoundSize!>>!File!
)
if not "%NetName%"=="没有发现网卡 可能已被卸载" (
echo.>>!File!
echo.>>!File!
echo.关于网卡的详细信息如下：>>!File!
echo.>>!File!
echo.    名称 ........... : !NetName!>>!File!
echo.>>!File!
echo.    MAC  ........... : !MacAddress!>>!File!
)
if not "%MacAddress%"=="无法获取 网卡已被禁用" (
for /f "tokens=2 delims={}" %%i in ('Wmic Nicconfig where "ipenabled='True'" Get ipaddress/Value') do set "IP=%%~i"
for /f delims^=^" %%i in ("!IP!") do set IP=%%~i
echo.>>!File!
echo.    内网 IP ........ : !IP!>>!File!
)
echo.>>!File!
echo.    当前状态 ....... : !NetWorking!>>!File!
echo.>>!File!
echo.>>!File!
echo.>>!File!
for /f "tokens=2 delims==" %%i in ('Wmic OS Get InstallDate /Value') do (
	set I=%%i
	set InstallDate=!I:~0,4! 年 !I:~4,2! 月 !I:~6,2! 日
)
echo 系统版本：............................. :!OS!>>!File!
echo.>>!File!
echo 系统初始安装日期：..................... : !InstallDate!>>!File!
echo.>>!File!
set Tim.2=%time%
call :TimeDifference !Tim.1! !Tim.2! Difference
echo.生成详细信息耗时：..................... : %Difference%>>!File!
for /f %%i in ("%date%") do set Dat=%%i
for /f "delims=." %%i in ("%Time%") do set Tim=%%i
echo.>>!File!
echo.此程序最后优化于：..................... : 2018 年 02 月 10 日>>!File!
echo.>>!File!
echo.以上信息生成于：%Dat% %Tim%>>!File!
echo.>>!File!
start !File!
del /a /f %Temp%\DxDiag.txt
Exit

:Space
set S=%~1
set Len.2=%~2
set Space=
for /l %%i in (10 -1 1) do if "!S:~%%i,1!"=="" set Len.1=%%i
set /a Len.3=!Len.2!-!Len.1!
for /l %%i in (1 1 !Len.3!) do set Space=!Space! 
set %~3=!Space!
goto :eof

:Minus
set Min.0=0
set Min.1=%~1
set Min.2=%~2
set Min.3=
set Min.1.Temp=
for /l %%i in (0 1 9) do set Min.1=!Min.1:%%i= %%i!
for %%i in (!Min.1!) do set Min.1.Temp=%%i !Min.1.Temp!
set Min.1=!Min.1.Temp!
for %%i in (!Min.1!) do (
	set Min.i=%%i
	if "!Min.2!"=="" set Min.2=0
	if !Min.0! Equ 10 set /a Min.i=!Min.i!-1
	if !Min.2:~-1! gtr !Min.i! (set Min.0=10) else set Min.0=0
	set /a Min.3.Temp=!Min.i!+!Min.0!-!Min.2:~-1!
	set Min.3=!Min.3.Temp!!Min.3!
	set Min.2=!Min.2:~0,-1!
	)
for /f "tokens=* delims=0" %%i in ("!Min.3!") do set Min.3=%%i
if "!Min.3!"=="" set Min.3=0
set %~3=!Min.3!
goto :eof

:Addition
set Add.1=%~1
set Add.2=%~2
set Add.3=
if "%~3"=="" goto :eof
set Add.3.Temp.1=
set Add.3.Temp.2=0
set Add.1.Temp=
for /l %%i in (64 -1 0) do (if "!Add.1:~%%i,1!"=="" set Add.1.Len=%%i
			    if "!Add.2:~%%i,1!"=="" set Add.2.Len=%%i)
if !Add.1.Len! lss !Add.2.Len! (set Add.1=%~2
				set Add.2=%~1)
for /l %%i in (0 1 9) do set Add.1=!Add.1:%%i=%%i !
for %%i in (!Add.1!) do set Add.1.Temp=%%i !Add.1.Temp!
for %%i in (!Add.1.Temp!) do (
	if "!Add.2!"=="" set Add.2=0
	set /a Add.3.Temp.1=%%i+!Add.2:~-1!+!Add.3.Temp.2!
	set Add.3=!Add.3.Temp.1:~-1!!Add.3!
	set Add.3.Temp.2=!Add.3.Temp.1:~0,-1!
	if "!Add.3.Temp.2!"=="" set Add.3.Temp.2=0
	set Add.2=!Add.2:~0,-1!
)
if !Add.3.Temp.2! neq 0 set Add.3=!Add.3.Temp.2!!Add.3!
for /f "tokens=* delims=0" %%i in ("!Add.3!") do set Add.3=%%i
if "!Add.3!"=="" set Add.3=0
set %~3=!Add.3!
goto :eof

:GetSize
set Bytes=%~1
call :Division !Bytes! 1152921504606846976 OK
if not "%OK:~0,2%"=="0." (
	set %~2=!OK!EB
	goto :eof
	) else (call :Division !Bytes! 1125899906842624 OK)
if not "%OK:~0,2%"=="0." (
	set %~2=!OK!PB
	goto :eof
	) else (call :Division !Bytes! 1099511627776 OK)
if not "%OK:~0,2%"=="0." (
	set %~2=!OK!TB
	goto :eof
	) else (call :Division !Bytes! 1073741824 OK)
if not "%OK:~0,2%"=="0." (
	set %~2=!OK!GB
	goto :eof
	) else (call :Division !Bytes! 1048576 OK)
if not "%OK:~0,2%"=="0." (
	set %~2=!OK!MB
	goto :eof
	) else (call :Division !Bytes! 1024 OK)
if not "%OK:~0,2%"=="0." (
	set %~2=!OK!KB
	goto :eof
	) else (
	set %~2=!Bytes!字节
	goto :eof)
:Division
set Div.1=%~1
set Div.2=%~2
set Div.3=
set Decimal=2
for /l %%i in (1 1 9) do set D.%%i=
if !Div.2! Equ 0 set %~3=Error & goto :eof
set Div.0=00000000000000000000000000000000
for /l %%i in (32 -1 1) do if "!Div.1:~%%i,1!"=="" set Div.1.Len=%%i
for /l %%i in (32 -1 1) do if "!Div.2:~%%i,1!"=="" set Div.2.Len=%%i
set Div.2=0!Div.2!
set /a Len.1=!Div.2.Len!+1
if !Div.1.Len! lss !Div.2.Len! (
	set Div.1.Len=!Div.2.Len!
	set Div.1=!Div.0:~-%Div.2.Len%,-%Div.1.Len%!!Div.1!
)
if "!Decimal!"=="" set Decimal=0
set /a Div.1.Len+=!Decimal!
set Div.1=0!Div.1!!Div.0:~,%Decimal%!
set Div.1.T=!Div.1:~,%Div.2.Len%!
set Div.2.T=0000000!Div.2!
set /a Len.2=!Div.2.Len!+7
for /l %%i in (1 1 9) do (set Div.i=0
	for /l %%j in (8 8 !Len.2!) do (
		set /a Div.i=1!Div.2.T:~-%%j,8!*%%i+Div.i
		set D.%%i=!Div.i:~-8!!D.%%i!
		set /a Div.i=!Div.i:~,-8!-%%i
	)
	set D.%%i=!Div.i!!D.%%i!
	set D.%%i=0000000!D.%%i:~-%Len.1%!
)
for /l %%l in (!Div.2.Len! 1 !Div.1.Len!) do (
	set Div.1.T=!L!!Div.1.T!!Div.1:~%%l,1!
	set Div.1.T=!Div.1.T:~-%Len.1%!
	if !Div.1.T! geq !Div.2! (
		set Div.3.T=1
		set Div.2.T=0000000!Div.1.T!
		for /l %%i in (2 1 9) do if !Div.2.T! geq !D.%%i! set Div.3.T=%%i
           	set Div.3=!Div.3!!Div.3.T!
		set Div.1.T=
		set Div.i=0
           	for %%i in (!Div.3.T!) do (
			for /l %%j in (8 8 !Len.2!) do (
                   		set /a Div.i=3!Div.2.T:~-%%j,8!-1!D.%%i:~-%%j,8!-!Div.i:~,1!%%2
                   		set Div.1.T=!Div.i:~1!!Div.1.T!
			)
           	)
	) else set Div.3=!Div.3!0
)
if %Decimal% gtr 0 set Div.3=!Div.3:~,-%Decimal%!.!Div.3:~-%Decimal%!
if "!Div.3:~1,1!" neq "." (
	for /f "tokens=* delims=0" %%i in ("!Div.3!") do set Div.3=%%i
)
if "!Div.3!" Equ "" set Div.3=0
set %~3=!Div.3!
goto :eof

:TimeDifference
set /a N=0
for /f "tokens=1-8 delims=.:" %%I in ("%~2:%~1") do (
	set /a N+=10%%I%%100*360000+10%%J%%100*6000+10%%K%%100*100+10%%L%%100
	set /a N-=10%%M%%100*360000+10%%N%%100*6000+10%%O%%100*100+10%%P%%100
)
set Sco=!N!
set /a S=N/360000,N=N%%360000,F=N/6000,N=N%%6000,M=N/100,N=N%%100
set T=%M% 秒 %N% 毫秒
set %~3=%T%
goto :eof

:Calc
set Cal.1=%~1
set Cal.2=%~2
set Cal.3=0
set Cal.4=
for %%i in (!Smart!) do (set /a Cal.3+=1
	if !Cal.3! Geq !Cal.1! (if !Cal.3! Lss !Cal.2! set Cal.4=!Cal.4! %%i))
for /f "tokens=6,7" %%i in ("!Cal.4!") do set /a Cal.4=%%j*256+%%i
set %~3=!Cal.4!
goto :eof

:Net
for /f "tokens=2 delims==" %%i in ('Wmic nic Where NetConnectionID!^=null Get MacAddress /Value 2^>nul') do set MacAddress=%%i
for /f "tokens=2 delims==" %%i in ('Wmic nic Where NetConnectionID!^=null Get Name /Value 2^>nul') do set NetName=%%i
if "%NetName%"=="" set NetName=没有发现网卡 可能已被卸载
if "%MacAddress%"=="" set MacAddress=无法获取 网卡已被禁用
Ping www.baidu.com>nul
if %errorlevel%==0 set NetWorking=已联网
if %errorlevel%==1 set NetWorking=未联网
goto :eof

:Inspect
title 获取硬件信息 - 正在检测运行环境，请稍等...
if /i "%SystemDrive%" Equ "X:" Title 此程序不支持 PE 环境，请安任意键退出！& Pause>nul & exit
Net User Guest /Active:Yes>nul 2>nul
if /i %Errorlevel% Neq 0 Title 当前账户权限不足，请以管理员身份运行！& Pause>nul & exit
set  Tit=关于电脑配置的简要信息如下：
set Titl=关于电脑配置的详细信息如下：
for /f "tokens=2 delims==" %%i in ('Wmic DiskDrive Get Model /Value^|Find /i /v "USB"') do (
	echo %%i>%Temp%\Temp.txt
	Attrib +h %Temp%\Temp.txt
	for /f %%j in ('Findstr /i "Vmware Vbox Virtual Qemu" %Temp%\Temp.txt') do (
		if "%%j" Neq "" (Color 03
				  set Tit=检测环境处于虚拟机中，以下信息可能不准：
				 set Titl=检测环境处于虚拟机中，以下信息可能不准：
	))
del /a /f %Temp%\Temp.txt >nul 2>nul
)
goto :eof

:CpuTest
cls
set Tim.3=!Time!
IF %1.==. (set A=200) ELSE set A=%1
set /a Portion=-2
set /a A=A*100/3+70
set /a B=A/10
for /l %%F in (1,1,!B!) do set /a F_%%F=2000
for /l %%F in (!A!,-132,100) do (
	set /a Portion+=2
	Title 获取硬件信息 - 正在进行 CPU 性能测试，请稍等... !Portion! %%
	set /a N=%%F/10
	set /a M=2*N-1
	set /a D=F_!N!*10000
	set /a F_!B!=D%%M
	set /a D=D/M
	set /a N=N-1
	for /L %%F IN (!N!,-1,1) do (
		set /a N=%%F
		set /a M=2*N-1
		set /a D=D*N+F_!N!*10000
		set /a F_!N!=D%%M
		set /a D=D/M
		set /a N=N-1
	)
	set /a P=NUM+D/10000
	set /a NUM=D%%10000
	if !P! Lss 1000 set P=000!P!
	set Pi=!Pi!!P:~-4!
)
set Pi=!Pi:~0,1!.!Pi:~1,-3!
set Tim.4=!Time!
Call :TimeDifference !Tim.3! !Tim.4! Difference
set /a Score=10000-Sco
Title 获取硬件信息 - CPU 性能测试结果
echo.
echo 经测试此 CPU 得分为：!Score! 分
echo.
echo.
set /p wangzhenjjcn=若要生成详细的电脑配置信息文件请直接回车：
Goto :Star