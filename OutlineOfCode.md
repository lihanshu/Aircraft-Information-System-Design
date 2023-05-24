
## 要求和思路纲要

### 语音信号处理

#### 基本要求

1、用计算机自带声卡采集语音信号；

2、显示语音信号的时域图和频域图；

3、加入数字滤波器提高语音信号质量；

4、对语音信号进行时频域分析（语谱图）。

#### 思路分析

思路一：间断分析，在录音记录的同时进行域分析
主要调用函数：audioRecorder( ) , 
可以调用但缺点是每次调用都会开关一次麦克风，
延迟十分严重， 无法实现要求的实时效果。即存在同步时间
考虑使用dsp的audioRecorder函数，但已经无法使用

思路二：整体分析，先录音记录后再进行域分析
%为了提高语音信号质量，需要播放判断
%实施思路：录音后播放+域分析，滤波后播放+域分析，对二者进行比较

思路一和思路二实现 ExampleForSpeech.m

思路三：思路1的优势(录音记录的同时进行域分析)+思路二的优势(录音一直打开可以减少同步时间)，利用GUI实现。包括：



SoundRecorderDemo.fig      GUI界面

SoundRecorderDemo.m        主函数

SoundRecorderDemo_export.m 备用调整


#### 参考资料


[实时音频采集及频谱显示](https://blog.csdn.net/zxylv/article/details/102751960)
[语音信号处理实验教程(拓展)](https://github.com/bastamon/sound_signal_process-matlab-/tree/master/)
[IIR滤波器的Matlab设计](https://www.cnblogs.com/armfly/p/15133691.html)



[语谱图分析参考1](https://blog.csdn.net/lzrtutu/article/details/78882715)
[语谱图分析参考2](https://blog.csdn.net/godloveyuxu/article/details/54135515)


[录音机GUI设置demo](https://www.bilibili.com/video/av21914026/)


实时信号处理的同步分析
![同步问题](https://pic2.zhimg.com/80/v2-cfc8ac9b873fe06b753d4d93af90dc65_720w.jpg)

```mermaid
gantt
　　　dateFormat　YYYY-MM-DD

　　　section 理论情况
　　　第i次记录时间　　    : des1, now,1w
　　　第i次同步时间 　　　 :des2, after des1, 5hour
　　　第(i+1)次记录时间　　    : des3, after des2,1w
　　　第(i+1)次同步时间 　　　 :des4, after des3, 5hour
　　　section 实际情况
　
　　　section 实际情况
　　　第i次记录时间　　    : des5, now,1w
　　　第i次同步时间 　　　 :des6, after des1, 3d
　　　第(i+1)次记录时间　　    : des7, after des6,1w
　　　第(i+1)次同步时间 　　　 :des8, after des7, 3d
```

### 基于SDR的飞机通信导航监视信号仿真实验


#### 实验要求
熟悉Matlab/LabVIEW操作环境

实现调幅或单边带的工作方式进行双向通话的功能仿真，理解高频/甚高频通信系统的基本原理。（产生一个数据文件，实现发送接收。）

甚高频全向信标系统设计实验：
实现模拟机载与地面VOR系统收发信号模拟，完成测向功能仿真。
（仿真地面台。不同VOR相对方位（度数不同）的产生信号要标准（基础要求））

仪表着陆系统设计实验：
模拟ILS系统机载与地面系统互通，完成航向和下滑道偏离测量功能仿真。
ATC应答机系统设计实验：
实现模拟机载应答机与地面二次雷达系统互通，实现询问和应答脉冲的识别。

实现方式：软件无线电，即Software Defined Radio，SDR就是基于通用的硬件平台上用软件来实现各种通信模块。

注意：不涉及到对天线的控制，天线的方向性

#### 思路分析
任务一：simulink+sdr接收机/**GUI**搭建通信系统进行仿真实验


simulink+sdr接收机:
文件参考
D:\SDR_Source\am\rtlsdr_rx\rtlsdr_am_envelope_demod.slx
D:\SDR_Source\am\rtlsdr_rx\rtlsdr_am_ssb_demod.slx
数据选用am_ssb.mat\am_dsb_tc.mat


GUI：
1.录音功能
2.调制功能
3.信道衰减
4.解调

任务二：GUI:
图片加载+位置确认+实际VOR方位角计算+信号调制解调相位比较+测量和误差


任务三： GUI，见[README.md](report_SDR/GUI_ILS/README.md)


#### 参考资料
[1]王明慧.MATLAB/Simulink通信仿真案例设计[J].通信电源技术,2021,38(02):117-119.DOI:10.19399/j.cnki.tpt.2021.02.033.

[matlab + simulink官方下载](https://ww2.mathworks.cn/campaigns/offers/download-rtl-sdr-ebook.html)

[AM-DSB-TC](https://wenku.baidu.com/view/0f7ee7e3aff8941ea76e58fafab069dc502247c3.html)

[SDR基础：FM收音机(96.4MHz中国之声)](https://www.bilibili.com/video/BV1Pb4y1x72i)

[VOR界面设计灵感](http://www.luizmonteiro.com/Learning_VOR_Sim.aspx)

[相关分析法](https://www.docin.com/p-1978518949.html)

[GNU Radio 中文社区 (microembedded.com)](http://gnuradio.microembedded.com/)
[simulink系列教程1](https://blog.csdn.net/shukebeta008/category_9596044.html)

[simulink+系列教程2](https://blog.csdn.net/OpenSourceSDR/article/details/120032450)

[通信系统建模](https://www.bilibili.com/video/BV1AA411b7EF?p=6)
[Aircraft-Information-System-Design ](https://gitee.com/aircraft-is-design/aircraft-information-system-design/tree/master/project-radio)
