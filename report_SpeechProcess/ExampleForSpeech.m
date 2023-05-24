%% 思路分析
%思路一：间断分析，录音记录的同时进行域分析
%主要调用函数：audioRecorder( ) , 
%可以调用但缺点是每次调用都会开关一次麦克风，
%延迟十分严重， 无法实现要求的实时效果。即存在同步时间
%考虑使用dsp的audioRecorder函数，但已经无法使用

%思路二：整体分析，先录音记录后再进行域分析
%为了提高语音信号质量，需要播放判断
%实施思路：录音后播放+域分析，滤波后播放+域分析，对二者进行比较

%思路三：思路1的优势(录音记录的同时进行域分析)+思路二的优势(录音一直打开可以减少同步时间)，可以利用GUI实现

%% 执行程序1
clear all
Fs = 48000        %采样频率
Duration = 1      %间隔时间
N = Fs * Duration %采样点数
ExcuteTime = 20   %执行时间
i = 0
Recorder = audioDeviceReader('NumChannels',1,'SampleRate',Fs,'SamplesPerFrame',N)
%录音器参数设置
while i < (ExcuteTime/Duration)
    i = i + 1;
    %将录音数据存入ReceiveData中 step (Recorder):打开录音机
    [ReceiveData, nOverrun] = step(Recorder)
    %对录音数据进行快速傅里叶变换
    y = abs(fftshift(fft(ReceiveData,N)/N));
    drawnow
    subplot(4,2,1)
    plot(ReceiveData,'Color','b','LineWidth',1)
    xlim([0 5000])
    title({'第',num2str(i*Duration),'s时的时域波形'});
    subplot(4,2,2)
    w= linspace(-Fs/2,Fs/2,N)
    plot(w,y)
    title({'第',num2str(i*Duration),'s时的频域波形'});
    xlim([0 5000])
    
    %滤波处理
    Wc = 0.1
    [b, a] = butter(4, Wc,'low');
    FilterData = filtfilt(b,a,ReceiveData); 
    subplot(4,2,3)
    plot(FilterData,'Color','b','LineWidth',1)
    title({'第',num2str(i*Duration),'s时的时域域波形(滤波后)'});
    xlim([0 5000]) % ylim([-0.5 0.5])
    y_filter = abs(fftshift(fft(FilterData,N)/N));
    subplot(4,2,4)
    plot(w,y_filter)
    title({'第',num2str(i*Duration),'s时的频域波形(滤波后)'});
    xlim([0 5000])
    
    %语谱图
    windowLength = 256;%帧长
    win = hamming(windowLength,'periodic');%窗口函数（汉明窗）
    overlap = 128; %帧移（一般为帧长的一半）
    ffTLength = windowLength; %做DFT的点数，一般和帧长一样
    subplot(4,2,[5 7])
    spectrogram(ReceiveData,win,overlap,ffTLength,Fs,'yaxis');
    title('实时语谱图(二维)')
    %title({'第',num2str(i*Duration),'s时的语谱图'})
    
    subplot(4,2,[6 8])
    [S,F,T,P] = spectrogram(ReceiveData,win,overlap,ffTLength,Fs);
    surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
    %view(0,90);  % 时谱图采用角度
    xlabel('Time(Seconds)'); ylabel('频率(Hz)');colorbar
    title('实时语谱图(三维)')
    %title({'第',num2str(i*Duration),'s时的语谱图(三维)'})
    %pause(0.2) %视觉暂留  
end
%% 执行程序2
clear all
Fs = 44100, nBits = 16, NumChannels = 1,Duration = 5
recObj = audiorecorder(Fs,nBits,NumChannels)
disp('Start speaking.')
recordblocking(recObj,Duration);
disp('End of Recording.');
data = getaudiodata(recObj)
t = [1/Fs:1/Fs:Duration]
sound(data,Fs)
plot(t,data),title('时域图')
DrawFFT(data,Fs)
spectrogram_two(data,Fs) 
spectrogram_three(data,Fs) 
% 滤波处理
Wc = 0.1
[b, a] = butter(4, Wc,'low');
Data = filtfilt(b,a,data); 

sound(Data,Fs)
plot(t,Data),title('时域图')
DrawFFT(Data,Fs)
spectrogram_two(Data,Fs) 
spectrogram_three(Data,Fs) 
%% 执行程序3

%DrawFFT 对输入信号进行快速傅里叶变换
function [  ] = DrawFFT( x, Fs )
L = length(x);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(x, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
figure()
plot(f, 2*abs(y(1:NFFT/2+1)));		%绘制频域图像
xlim([0 4000])
title('幅度谱');
xlabel('Frequency (Hz)');
ylabel('|y(f)|');
end

function [ ] = spectrogram_two(ReceiveData,Fs)
windowLength = 256;%帧长
win = hamming(windowLength,'periodic');%窗口函数（汉明窗）
overlap = 128; %帧移（一般为帧长的一半）
ffTLength = windowLength; %做DFT的点数，一般和帧长一样
figure()
spectrogram(ReceiveData,win,overlap,ffTLength,Fs,'yaxis');
title('语谱图(二维)')
end
function [ ] = spectrogram_three(ReceiveData,Fs)
windowLength = 256;%帧长
win = hamming(windowLength,'periodic');%窗口函数（汉明窗）
overlap = 128; %帧移（一般为帧长的一半）
ffTLength = windowLength; %做DFT的点数，一般和帧长一样
figure()
[S,F,T,P] = spectrogram(ReceiveData,win,overlap,ffTLength,Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
xlabel('Time(Seconds)'); ylabel('频率(Hz)');colorbar
title('语谱图(三维)')
end