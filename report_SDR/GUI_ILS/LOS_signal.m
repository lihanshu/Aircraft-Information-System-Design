function [CDI,DDM] = LOS_signal(theta)
%信号发射
t = linspace(0,1,48000);
w = 1e4;
%5 两信号相对于下滑道张开的角度 
%theta 飞机相对于跑道头的角度，正为右，负为左
f1 = power(cos((theta-5)*pi/180),8); 
f2 = power(cos((theta+5)*pi/180),8); 
u1 = f1*(1+0.2*sin(2*pi*90*t)).*sin(2*pi*w*t);
u2 = f2*(1+0.2*sin(2*pi*150*t)).*sin(2*pi*w*t);
u = u1 + u2;
% figure(1)
% plot(t,u)
% DrawFFT(u, 48000)
%信号接收
u = u.* sin(2*pi*w*t);
[B,A] = butter(4,1000/(48000/2),'low');
u_filter = filtfilt(B,A,u); % 超外差
u_filter = u_filter - (f1+f2);
[B,A] = butter(4,120/(48000/2),'low');
u1 = 5.26*filtfilt(B,A,u_filter)+5.6; % 90
[B,A] = butter(4,120/(48000/2),'high');
u2 = 12.5*filtfilt(B,A,u_filter); % 150
u1 = u1(10000:40000);
u2 = u2(10000:40000);
% figure(1)
% plot(t(10000:40000),u2)
% DrawFFT(u2, 48000)
%计算
u1 = max(abs(fftshift(fft(u1))))/48000-0.0170;
u2 = max(abs(fftshift(fft(u2))))/48000; 
% assignin('base','u1',u1) 
% assignin('base','u2',u2) 
%判决 2.941822266788741e-05
if(abs(u1-u2)>=2.942e-5)  
    if(u1-u2>=2.942e-5)panj
       CDI = "飞右";
    elseif(u2-u1>=2.942e-5)
       CDI = "飞左";
    end
else
    CDI = "对准"; 
end
umax = max(u1,u2);
DDM = u1/umax-u2/umax;
if  DDM > 0
    DDM = (0.155/0.002573)*DDM;
elseif  DDM <= 0
    DDM = (0.155/0.001677)*DDM;
end
DDM = abs(DDM);
end

function [  ] = DrawFFT( x, Fs )
L = length(x);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(x, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
figure()
plot(f, 2*abs(y(1:NFFT/2+1)));		%绘制频域图像
xlim([20 200]) 
% title('幅度谱');
xlabel('Frequency (Hz)');
ylabel('|y(f)|');
end