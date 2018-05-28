@echo off 
echo start proxy setting..........
echo Close Explorer。。。。。
echo  Any key to continue ctrl+c to exit��
pause;
taskkill /f /im iexplore.exe
taskkill /f /im chrome.exe
taskkill /f /im SougouExplorer.exe
taskkill /f /im 360Chrome.exe
taskkill /f /im QQBrowser.exe

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "IP:PORT" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "<local>;10.*.*.*;*.192.168.*.*;*.videojj.com;*.baidu.com;*.bdstatic.com;*.iqiyi.com;*.taobao.com;*.163.com;*.weibo.com;*.sohu.com;*.soso.com;*.youku.com;*.tudou.com;*.renren.com;*.netease.com;*.taobaocdn.com;*.wallcoo.com;*.cn;*.fminutes.com;*.gtimg.com;*.gooooal.com;*.sgamer.com;*.youdao.com;*.duowan.com;*1;*2;*3;*4;*5;*6;*7;*8;*9;*0;*.qnssl.com;*.tv;*.douyu.com;*.zhanqi.com;*.115.com;*.acfun.com;*.tgbus.com;*.soku.com;*.*.cn;*.cnaba.com;*.alipay.com;*.1688.com;*.qq.com;*.microsoft.com;*.apple.com;*.oschina.net;*.jianshu.com;*.jiyoujia.com;*.com.cn;*.dribbble.com;*.cnblogs.com;*.zhihu.com;*.yao-shang-wang.com;*.myazure.org;*.juejin.im;*.sina.com;*.jd.com;*.suning.com;*.miaozhen.com;*.hao123.com;*.58.com;*.fang.com;*.ctrip.com;*.guazi.com;*.qunar.com;*.toutiao.com;*.vip.com;*.bilibili.com;*.renrenche.com;*.xinhuanet.com;*.cctv.com;*.mgtv.com;*.showself.com;*.huya.com;*.comlongzhu.com;*.ganji.com;*.baixing.com;*.lianjia.com;*.xiaozhu.com;*.dianping.com;*.bitauto.com;*.ccb.com;*.bankcomm.com;*china.com;*.qiniu.com;*.tainyancha.com;*.58pic.com;*.xiazaiba.com;*.apple.com;*.cr173.com;*.net;*.onlinedown.net;*.91.com;*.mydrivers.com;*.steam.com;*.baozoumanhua.com;*.1e100.net;*.amazoneaws.com;*.ctinets.com;*.bdimg.com;*.bdstatic.com;*.alicdn.com;*.mediav.com;*.vultr.com;*.aliyun.com;" /f

ipconfig /flushdns
color 2
echo Sucess set PROXY
echo any key to continue
pause>nul