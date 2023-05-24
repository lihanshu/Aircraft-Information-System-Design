function varargout = SoundRecorderDemo(varargin)
% SOUNDRECORDERDEMO MATLAB code for SoundRecorderDemo.fig
%      SOUNDRECORDERDEMO, by itself, creates a new SOUNDRECORDERDEMO or raises the existing
%      singleton*.
%
%      H = SOUNDRECORDERDEMO returns the handle to a new SOUNDRECORDERDEMO or the handle to
%      the existing singleton*.
%
%      SOUNDRECORDERDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOUNDRECORDERDEMO.M with the given input arguments.
%
%      SOUNDRECORDERDEMO('Property','Value',...) creates a new SOUNDRECORDERDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SoundRecorderDemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SoundRecorderDemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SoundRecorderDemo

% Last Modified by GUIDE v2.5 28-May-2022 15:06:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SoundRecorderDemo_OpeningFcn, ...
                   'gui_OutputFcn',  @SoundRecorderDemo_OutputFcn, ...
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


% --- Executes just before SoundRecorderDemo is made visible.
function SoundRecorderDemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SoundRecorderDemo (see VARARGIN)

% Choose default command line output for SoundRecorderDemo
handles.output = hObject;
handles.recObj = audiorecorder(48000, 16, 2,-1);
handles.recObj.TimerFcn={@RecDisplay,handles};
handles.recObj.TimerPeriod=0.25;
handles.playSpeed=1;
handles.order = 4;
handles.filter= 1e3;
handles.playselect = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SoundRecorderDemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SoundRecorderDemo_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.recObj)
handles.playselect  =  0;
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.playselect  ==  0
    handles.myRecording = getaudiodata(handles.recObj);
    handles.playObj = audioplayer(handles.myRecording,handles.recObj.SampleRate);
    play(handles.playObj);
end
if handles.playselect  ==  1
    Data = evalin('base','Data_filter')  ;
    Fs = 48000;
    sound(Data,Fs);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile(['soundDemo' num2str(handles.playSpeed) '.wav'],'Save recorded sound');
if file
    audiowrite([path '\' file],handles.myRecording,handles.playSpeed*handles.recObj.SampleRate)
end

function RecDisplay(hObject, eventdata,handles)
%handles
handles.myRecording = getaudiodata(handles.recObj);
% axes(handles.axes1)
plot(handles.axes1,(1:length(handles.myRecording))/handles.recObj.SampleRate,handles.myRecording)
title(handles.axes1,'Real-Time Time Domain Figure')
ylim(handles.axes1,[-0.25 0.25]),xlabel(handles.axes1,'Time(Seconds)'), ylabel(handles.axes1,'Amplitude')
drawnow;
Fs = 48000;
L = length(handles.myRecording);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(handles.myRecording, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
plot(handles.axes2, 2*abs(y(1:NFFT/2+1)));		%绘制频域图像
title(handles.axes2,'Real-Time Frequency Domain Figure')
xlim(handles.axes2,[0 12000]),xlabel(handles.axes2,'Frequency(Hz)'), ylabel(handles.axes2,'Amplitude')
drawnow;


% % 参数设置2
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.order = str2double(get(hObject,'String'));
%handles.playSpeed=str2double(get(hObject,'String'));
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fs = 48000;
fc = handles.filter
Wc = fc/(Fs/2)
n  =  handles.order
[b, a] = butter(n, Wc,'low');
handles.myRecording = getaudiodata(handles.recObj);
Data = filtfilt(b,a,handles.myRecording); 
assignin('base','Data_filter',Data)
%绘制时域图像
plot(handles.axes1,(1:length(Data))/handles.recObj.SampleRate,Data)
ylim(handles.axes1,[-0.25 0.25]),xlabel(handles.axes1,'Time(Seconds)'), ylabel(handles.axes1,'Amplitude')
title(handles.axes1,'Time Domain Figure After Filtering')
drawnow;
%绘制频域图像
L = length(Data);
NFFT = 2^nextpow2(L);          		%确定FFT变换的长度
y = fft(Data, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);	%频率向量
plot(handles.axes2, 2*abs(y(1:NFFT/2+1)));	
xlim(handles.axes2,[0 12000]),xlabel(handles.axes2,'Frequency(Hz)'), ylabel(handles.axes2,'Amplitude')
title(handles.axes2,'Frequency Domain Figure After Filtering')
drawnow;
handles.playselect   =  1;
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ReceiveData = getaudiodata(handles.recObj);
Fs = 48000;
windowLength = 256;%帧长
win = hamming(windowLength,'periodic');%窗口函数（汉明窗）
overlap = 128; %帧移（一般为帧长的一半）
ffTLength = windowLength; %做DFT的点数，一般和帧长一样
[S,F,T,P] = spectrogram(ReceiveData(:,1),win,overlap,ffTLength,Fs);
axes(handles.axes1)
spectrogram(ReceiveData(:,1),win,overlap,ffTLength,Fs,'yaxis');
xlabel('Time(Seconds)'); ylabel('Frequency(kHz)');colorbar
title('语谱图(二维)')
axes(handles.axes2)
surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
xlabel('Time(Seconds)'); ylabel('Frequency(Hz)');colorbar
title('语谱图(三维)')



% 参数设置
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.filter=str2double(get(hObject,'String'));
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end