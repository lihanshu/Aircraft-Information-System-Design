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

#### 文件介绍


[ExampleForSpeech.m](ExampleForSpeech.m)包括了思路一和思路二的实现；

`SoundRecorderDemo.m`和`SoundRecorderDemo.fig`是思路三实现，`SoundRecorderDemo_export.m`是GUI的备份和导出。