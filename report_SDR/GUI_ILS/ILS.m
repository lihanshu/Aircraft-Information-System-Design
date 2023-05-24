function varargout = ILS(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ILS_OpeningFcn, ...
                   'gui_OutputFcn',  @ILS_OutputFcn, ...
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


% --- Executes just before ILS is made visible.
function ILS_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.X = 0;
handles.Y = 1400;
%a=0;b=0.9/13;c=-300*b;
handles.Z = handles.Y*0.9/13-300*0.9/13;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ILS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ILS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton1_Callback(hObject, eventdata, handles)
global p1 
if ~isempty(p1)
    delete(p1);
end
pic2 = imread('HSI.png');
axes(handles.axes2);
imagesc([-300 300], [300 -300], flip(pic2,1)); 
axis off
hold on

axes(handles.axes1);
color=[0;0;0;0;0;0;0;0];
plot_cuboid([0,0,0],[0,1400,100],color);
color=[1;1;1;1;1;1;1;1];
plot_cuboid([50,100,0],[-50,1400,0],color);
text(0,-5,105,'航向面');
text(55,105,0,'跑道');
text(10,-15,0,'LOC台');
text(110,300,0,'GS台');
text(0,1600,85,'飞机初始位置');
plot(0,0,'Marker','^','LineWidth',3,'Color','r');
%LOC台位置
plot(100,300,'Marker','^','LineWidth',3,'Color','r');
%GS台位置
plot3(0,1600,90,'Marker','*','LineWidth',3,'Color','r');
%初始飞机位置 
%下画面平面方程为z=ax+by+c。
a=0;b=0.9/13;c=-300*b;
x=linspace(-50,50,100);
y=linspace(300,1500,100);
[x,y]=meshgrid(x,y);
z=a*x+b*y+c;
plot3(x,y,z,'Color',[0.86,0.86,0.86]);
text(5,800,40,'下滑线','rotation',35);
text(55,400,20,'z=0.692y-20.7692','interpreter','latex');
text(55,400,30,'下滑面(3.96^{\circ})');
%atan(0.9/13)*180/3.1415  3.9604
txt = xlabel('$X$');
set(txt, 'Interpreter', 'latex');
txt = ylabel('$Y$');
set(txt, 'Interpreter', 'latex');
txt = zlabel('$Z$');
set(txt,'rotation',60, 'Interpreter', 'latex');
hold on
axis on
rotate3d on

% --- Executes on button press in pushbutton3.
function pushbutton2_Callback(hObject, eventdata, handles)
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
axes(handles.axes1);
p1 = plot3(handles.axes1,handles.X ,handles.Y ,handles.Z,'o','Color','black','LineWidth',1.2);
drawnow
rotate3d on
%theta 飞机相对于跑道头的角度，正为右，负为左
theta =  atan((handles.X)/(handles.Y-300));
[CDI,DDM] = LOS_signal(theta);
set(handles.edit4,'string',CDI);
DDM = 100/0.155*DDM;
Fact =  360 - DDM; 
Fact =  90 + Fact ; 
p2 = plot(handles.axes2,[0,250*cos(2*pi*Fact/360)],[0,-250*sin(2*pi*Fact/360)],'LineWidth',1.5,'Color','r');
p3 = plot(handles.axes2,250*cos(2*pi*Fact/360),-250*sin(2*pi*Fact/360),'p','LineWidth',1.5,'Color','r');
drawnow

theta =  atan((handles.Z)/(handles.Y-300));
[CDI,DDM] = GS_signal(theta-3.96*pi/180);
set(handles.edit5,'string',CDI);
DDM = 100/0.155*DDM;
Fact =  360 - DDM; 
Fact =  90 + Fact ; 
p4 = plot(handles.axes2,[0,250*cos(2*pi*Fact/360)],[0,-250*sin(2*pi*Fact/360)],'LineWidth',1.5,'Color','b');
p5 = plot(handles.axes2,250*cos(2*pi*Fact/360),-250*sin(2*pi*Fact/360),'p','LineWidth',1.5,'Color','b');
drawnow

function edit1_Callback(hObject, eventdata, handles)
handles.X = str2double(get(hObject,'String')) ;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
handles.Y = str2double(get(hObject,'String')) ;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
handles.Z = str2double(get(hObject,'String')) ;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
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

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end