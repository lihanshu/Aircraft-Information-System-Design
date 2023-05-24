function ph = VOR_signal(theta)
t = linspace(0,1,48000);
w = 1e4;
U_base = cos(2*pi*996*t + 48/30*cos(2*pi*30*t));
U_base = (1 + 0.3*U_base).* cos(2*pi*w*t);
U_change = cos(2*pi*30*t - pi*theta/180).*cos(2*pi*w*t);
U = U_base + U_change;
U_filter = U.*cos(2*pi*w*t); 
[B,A] = butter(4,1500/(48400/2),'low');
U_filter = filtfilt(B,A,U_filter); % 超外差
[B,A] = butter(4,35/(48400/2),'low');
U_30_change = filtfilt(B,A,U_filter); 
[B,A] = butter(4,20/(48400/2),'high');
U_30_change = filtfilt(B,A,U_30_change);% 可变相位
[B,A] = butter(4,[948/(48400/2) 1044/(48400/2)]);
U_30_base = filtfilt(B,A,U_filter);  %带通滤波
U_30_base =[0 diff(U_30_base)]; 
U_30_base = abs(hilbert(U_30_base)); 
[B,A] = butter(4,20/(48400/2),'high');
U_30_base = filtfilt(B,A,U_30_base);
[B,A] = butter(4,40/(48400/2),'low');
U_30_base = 666*filtfilt(B,A,U_30_base);% 恒定相位 

% figure(1)
% plot(t,U_30_base)
% figure(2)
% DrawFFT(U_30_base,48000)

t = t(9600:38400);
U_30_base = U_30_base(9600:38400);
U_30_change = U_30_change(9600:38400);
% 计算相位差
N = length(t);
IX = sum(U_30_base.*U_30_base)/N ;
IY = sum(U_30_change.*U_30_change)/N;
IXY = sum(U_30_change.*U_30_base)/N;
c = 180*acos(2*IXY/(4*IX*IY)^0.5)/pi ;
if theta < 90
    c = 90 - c;
elseif  theta <= 180
     c = c + 90 ;
elseif  theta <= 270
     c = c + 90 ;
elseif  theta <= 360
     c = 450- c ;
end

ph = c ;
end

function [  ] = DrawFFT( x, Fs )
L = length(x);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(x, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
figure(2)
plot(f, 2*abs(y(1:NFFT/2+1)));		%绘制频域图像
xlim([0 100]) 
% title('幅度谱');
xlabel('Frequency (Hz)');
ylabel('|y(f)|');
end