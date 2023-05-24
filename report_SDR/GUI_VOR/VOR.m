function varargout = VOR(varargin)
% VOR MATLAB code for VOR.fig
%      VOR, by itself, creates a new VOR or raises the existing
%      singleton*.
%
%      H = VOR returns the handle to a new VOR or the handle to
%      the existing singleton*.
%
%      VOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOR.M with the given input arguments.
%
%      VOR('Property','Value',...) creates a new VOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VOR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VOR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VOR

% Last Modified by GUIDE v2.5 03-Jun-2022 16:40:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VOR_OpeningFcn, ...
                   'gui_OutputFcn',  @VOR_OutputFcn, ...
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


% --- Executes just before VOR is made visible.
function VOR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VOR (see VARARGIN)

% Choose default command line output for VOR
handles.output = hObject;
handles.X = 100;
handles.Y = 100;
% handles.select = 0;
handles.theta  = 303.69;
% handles.plot1 = 0;
% handles.plot2 = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VOR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VOR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
handles.X = get(handles.slider1,'value');
set(handles.edit1,'string',handles.X);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
handles.Y = get(handles.slider2,'value');
set(handles.edit2,'string',handles.Y);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.X = str2double(get(hObject,'String')) ;
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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.Y = str2double(get(hObject,'String')) ;
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
pic = imread('background_s.jpg');
handles.im = imshow(pic);
axis on
hold on
set(handles.im,'Pickableparts','none');
set(handles.axes1,'ButtonDownFcn',@mycallbackfcn);
plot(handles.axes1,400,300,'p','LineWidth',3,'Color','red')

pic2 = imread('Compass.jfif');
axes(handles.axes2);
imagesc([-390 390], [390 -390], flip(pic2,1)); 
% ylim([0 50])
axis off
hold on

 

function mycallbackfcn(hObject,eventdata,handles)
global p1 p2 p3 p4 p5
if ~isempty(p1)
    delete(p1);
end
if ~isempty(p2)
    delete(p2);
end
if ~isempty(p3)
    delete(p3);
end
if ~isempty(p4)
    delete(p4);
end
if ~isempty(p5)
    delete(p5);
end
handles = guidata(hObject);
pos = get(hObject,'Currentpoint');
set(handles.edit1,'string',pos(1,1));
set(handles.edit2,'string',pos(1,2));
p1 = plot(handles.axes1,pos(1,1),pos(1,2),'o','Color','black','LineWidth',1.2);
drawnow;
Theory = theta_js(pos(1,1), pos(1,2));
handles.theta = Theory;
set(handles.edit3,'string',Theory);
% 实际方位角绘制P2
Theory =  360 - Theory; 
Theory =  90 + Theory ; 
% plot([x1,x2],[y1,y2])
p2 = plot(handles.axes2,[0,250*cos(2*pi*Theory/360)],[0,-250*sin(2*pi*Theory/360)],'LineWidth',1,'Color','red');
p4 = plot(handles.axes2,250*cos(2*pi*Theory/360),-250*sin(2*pi*Theory/360),'p','LineWidth',1,'Color','red');
axes(handles.axes2);
% 测量方位角绘制P3
theta = handles.theta;
ph = VOR_signal(theta);
set(handles.edit4,'string',ph);
Fact =  360 - ph; 
Fact =  90 + Fact ; 
p3 = plot(handles.axes2,[0,250*cos(2*pi*Fact/360)],[0,-250*sin(2*pi*Fact/360)],'LineWidth',1,'Color','blue');
p5 = plot(handles.axes2,250*cos(2*pi*Fact/360),-250*sin(2*pi*Fact/360),'p','LineWidth',1,'Color','blue');
% 误差
error = roundn(handles.theta - ph,-3) ;
set(handles.edit5,'string',error);
guidata(hObject,handles);
drawnow;





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p1 p2 p3 p4 p5
if ~isempty(p1)
    delete(p1);
end
if ~isempty(p2)
    delete(p2);
end
if ~isempty(p3)
    delete(p3);
end
if ~isempty(p4)
    delete(p4);
end
if ~isempty(p5)
    delete(p5);
end
% 实际
p1 = plot(handles.axes1,handles.X,handles.Y,'o','Color','black','LineWidth',1.2);
Theory = theta_js(handles.X, handles.Y);
set(handles.edit3,'string',Theory);
handles.theta = Theory;
Theory =  360 - Theory; 
Theory =  90 + Theory ; 
p2 = plot(handles.axes2,[0,250*cos(2*pi*Theory/360)],[0,-250*sin(2*pi*Theory/360)],'LineWidth',1,'Color','red');
p4 = plot(handles.axes2,250*cos(2*pi*Theory/360),-250*sin(2*pi*Theory/360),'p','LineWidth',1,'Color','red');
axes(handles.axes2);
% 测量
theta = handles.theta;
ph = VOR_signal(theta);
set(handles.edit4,'string',ph);
Fact =  360 - ph; 
Fact =  90 + Fact ; 
p3 = plot(handles.axes2,[0,250*cos(2*pi*Fact/360)],[0,-250*sin(2*pi*Fact/360)],'LineWidth',1,'Color','blue');
p5 = plot(handles.axes2,250*cos(2*pi*Fact/360),-250*sin(2*pi*Fact/360),'p','LineWidth',1,'Color','blue');
% 误差
error = roundn(handles.theta - ph,-3) ;
set(handles.edit5,'string',error);

guidata(hObject,handles);
drawnow;

function edit3_Callback(hObject, eventdata, handles)



function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
