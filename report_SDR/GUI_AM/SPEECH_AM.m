function varargout = SPEECH_AM(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SPEECH_AM_OpeningFcn, ...
                   'gui_OutputFcn',  @SPEECH_AM_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SPEECH_AM is made visible.
function SPEECH_AM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SPEECH_AM (see VARARGIN)

% Choose default command line output for SPEECH_AM
handles.output = hObject;
handles.recObj = audiorecorder(48000, 16, 1);
handles.recObj.TimerFcn={@RecDisplay,handles};
handles.recObj.TimerPeriod=0.25;
handles.carrier = 10e3;
handles.A_0     =  3 ;
handles.playselect   =  0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SPEECH_AM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SPEECH_AM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
record(handles.recObj);

% --- Executes on button press in pushbutton3.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.recObj)
handles.playselect  =  0;
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
handles.myRecording = getaudiodata(handles.recObj);
t = (1:length(handles.myRecording))/handles.recObj.SampleRate;
assignin('base','t',t) 
% 调制
fc = handles.carrier;
A_0 = handles.A_0  ;
x_am = (A_0+(handles.myRecording)').*cos(2*pi*fc*t);
plot(handles.axes1,t,x_am )
title(handles.axes1,'AM Time Domain Figure')
ylim(handles.axes1,[-0.5-handles.A_0   0.5+handles.A_0 ]),xlabel(handles.axes1,'Time(Seconds)'), ylabel(handles.axes1,'Amplitude')
drawnow;
assignin('base','x_am',x_am) 
Fs = 48000;
L = length(x_am);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(x_am, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
plot(handles.axes2, f,2*abs(y(1:NFFT/2+1)));		%绘制频域图像
title(handles.axes2,'AM Frequency Domain Figure')
xlim(handles.axes2,[handles.carrier - 4000  handles.carrier + 4000]);
xlabel(handles.axes2,'Frequency(Hz)'), ylabel(handles.axes2,'Amplitude')
drawnow;

function pushbutton5_Callback(hObject, eventdata, handles)
% 信号传输 ：加性高斯白噪声信道
snr = 30; %10
x_am = evalin('base','x_am')  ;
t = evalin('base','t')  ;
x_am_snr = awgn(x_am,snr);
assignin('base','x_am_snr',x_am_snr) 
plot(handles.axes1,t,x_am_snr)
title(handles.axes1,'Transmitted Signal Time Domain Figure')
ylim(handles.axes1,[-0.5-handles.A_0   0.5+handles.A_0 ])
xlabel(handles.axes1,'Time(Seconds)'), ylabel(handles.axes1,'Amplitude')
drawnow;
Fs = 48000;
L = length(x_am_snr);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(x_am_snr, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
plot(handles.axes2, f,2*abs(y(1:NFFT/2+1)));		%绘制频域图像
title(handles.axes2,'Transmitted Signal Frequency Domain Figure')
xlim(handles.axes2,[handles.carrier - 4000  handles.carrier + 4000])
xlabel(handles.axes2,'Frequency(Hz)'), ylabel(handles.axes2,'Amplitude')
drawnow;



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% 信号解调
x_am_snr = evalin('base','x_am_snr')  ;
t = evalin('base','t')  ;
fc = handles.carrier;              %载波频率
x_de_pre = x_am_snr.*cos(2*pi*fc*t);
x_de = 2.*lowpass(x_de_pre,8000,48000)- handles.A_0 ;
assignin('base','x_de',x_de) 
plot(handles.axes1,t,x_de)
title(handles.axes1,'Demodulated Signal Time Domain Figure')
ylim(handles.axes1,[-0.5 0.5]),xlabel(handles.axes1,'Time(Seconds)'), ylabel(handles.axes1,'Amplitude')
drawnow;
Fs = 48000;
L = length(x_de);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(x_de, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
plot(handles.axes2, 2*abs(y(1:NFFT/2+1)));		%绘制频域图像
title(handles.axes2,'Demodulated Signal Frequency Domain Figure'),ylim(handles.axes2,[0 0.01])
xlim(handles.axes2,[0 8000]),xlabel(handles.axes2,'Frequency(Hz)'), ylabel(handles.axes2,'Amplitude')
drawnow;
handles.playselect   =  1;
guidata(hObject, handles);

% --- Executes on button press in pushbutton7.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.playselect  ==  0
    handles.myRecording = getaudiodata(handles.recObj);
    handles.playObj = audioplayer(handles.myRecording,handles.recObj.SampleRate);
    play(handles.playObj);
end
if handles.playselect  ==  1
    x_de = evalin('base','x_de')  ;
    Fs = 48000;
    sound(x_de,Fs);
end
guidata(hObject,handles);


function RecDisplay(hObject, eventdata,handles)
%handles
handles.myRecording = getaudiodata(handles.recObj);
% axes(handles.axes1)
plot(handles.axes1,(1:length(handles.myRecording))/handles.recObj.SampleRate,handles.myRecording)
title(handles.axes1,'Real-Time Time Domain Figure')
ylim(handles.axes1,[-0.5 0.5]),xlabel(handles.axes1,'Time(Seconds)'), ylabel(handles.axes1,'Amplitude')
drawnow;
Fs = 48000;
L = length(handles.myRecording);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(handles.myRecording, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
plot(handles.axes2, 2*abs(y(1:NFFT/2+1)));		%绘制频域图像
title(handles.axes2,'Real-Time Frequency Domain Figure')
ylim(handles.axes2,[0 0.01]);
xlim(handles.axes2,[0 8000]),xlabel(handles.axes2,'Frequency(Hz)'), ylabel(handles.axes2,'Amplitude')
drawnow;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.carrier = str2double(get(hObject,'String')).*1000 ;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
