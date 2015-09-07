function varargout = Simpleone(varargin)
% SIMPLEONE MATLAB code for Simpleone.fig
%      SIMPLEONE, by itself, creates a new SIMPLEONE or raises the existing
%      singleton*.
%
%      H = SIMPLEONE returns the handle to a new SIMPLEONE or the handle to
%      the existing singleton*.
%
%      SIMPLEONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLEONE.M with the given input arguments.
%
%      SIMPLEONE('Property','Value',...) creates a new SIMPLEONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simpleone_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simpleone_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Simpleone

% Last Modified by GUIDE v2.5 20-Aug-2015 14:57:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simpleone_OpeningFcn, ...
                   'gui_OutputFcn',  @Simpleone_OutputFcn, ...
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


% --- Executes just before Simpleone is made visible.
function Simpleone_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simpleone (see VARARGIN)

% Choose default command line output for Simpleone
handles.output = hObject;

set(handles.slider, 'Max', 10);
SliderStepX = 1/(10-0);
set(handles.slider, 'SliderStep', [SliderStepX 1]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Simpleone wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Simpleone_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function SetLable_Callback(hObject, eventdata, handles)
% hObject    handle to SetLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
SetLable=str2double(get(hObject,'String'));
handles.lable_inx = cell(1,SetLable);
for i=1:1:SetLable
    handles.lable_inx{i}.PixelList = [];
end
% handles.matFrame{handles.counter} =struct('PixelList',[]);
handles.SetLable = SetLable;
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of SetLable as text
%        str2double(get(hObject,'String')) returns contents of SetLable as a double


% --- Executes during object creation, after setting all properties.
function SetLable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SetLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CurrentLable_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CLable;
handles=guidata(hObject);
CLable=str2double(get(hObject,'String'));
switch CLable
    case 1
        set(handles.edit4,'String','Red');
    case 2
        set(handles.edit4,'String','Green');
    case 3
        set(handles.edit4,'String','Blue');
    case 4
        set(handles.edit4,'String','Yellow');
    case 5
        set(handles.edit4,'String','Magenta');
    case 6
        set(handles.edit4,'String','Cyan');
    case 7
        set(handles.edit4,'String','White');
end
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of CurrentLable as text
%        str2double(get(hObject,'String')) returns contents of CurrentLable as a double


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function CurrentLable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB code file');

if isequal(FileName,0)
   msgbox('User selected Cancel');
else
    load(FileName);
    handles = guidata(hObject);
    handles.rawEachFrame = rawEachFrame;
    handles.raw = rawEachFrame;
    handles.FileName = FileName;
    handles.Maxindex = numel(rawEachFrame);
    [dimx,dimy]=size(rawEachFrame{1,1});
    handles.xdim = dimx;
    handles.ydim = dimy;
    
    handles.matFrame = cell(1,handles.Maxindex);
%     handles.matFrame{1} =struct('figure',zeros(handles.xdim,handles.ydim),'PixelList',cell(1,handles.SetLable));
    
    handles.counter = 1;
    handles.Img = rawEachFrame{1,1};
    handles.R=handles.Img;
    handles.G=handles.Img;
    handles.B=handles.Img;
    guidata(hObject, handles);
    
    axes(handles.axes1);
    imshow(rawEachFrame{1,1});
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
    set(handles.GoToFrame,'String',num2str(handles.counter));
end
    


% --- Executes on button press in goback.
function goback_Callback(hObject, eventdata, handles)
% hObject    handle to goback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

% if Saveflag==0
%     choice = questdlg('Directly going back without Save will lose all the current work! Do you want to continue?',...
% 	'Warning', ...
% 	'Yes','No','No');
% % Handle response
%    switch choice
%     case 'Yes'
        handles.counter = handles.counter - 1;
%     case 'No'
%         return;
%    end
%    Saveflag = 1;
% 
% else
%     handles.counter = handles.counter - 1;
% end

if handles.counter < 1
    handles.counter = handles.counter + 1;
    msgbox('Wrong index')
else
    handles.Img=handles.rawEachFrame{1,handles.counter};
    handles.R=handles.Img;
    handles.G=handles.Img;
    handles.B=handles.Img;
%     handles.matFrame{handles.counter} =struct('PixelList',[]);
    guidata(hObject, handles);
    
    axes(handles.axes1);
    imshow(handles.rawEachFrame{handles.counter}); 
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
    set(handles.GoToFrame,'String',num2str(handles.counter));
end


% --- Executes on button press in gonext.
function gonext_Callback(hObject, eventdata, handles)
% hObject    handle to gonext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject); 
handles.counter = handles.counter + 1;
 if handles.counter > handles.Maxindex
     handles.counter = handles.counter - 1;
     msgbox('Wrong index') 
 else
     handles.Img=handles.rawEachFrame{handles.counter};
     handles.R=handles.Img;
     handles.G=handles.Img;
     handles.B=handles.Img;
%      handles.matFrame{handles.counter} =struct('PixelList',[]);
     guidata(hObject, handles);
     
     axes(handles.axes1);
     imshow(handles.rawEachFrame{handles.counter});
     
     set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
     set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
     set(handles.GoToFrame,'String',num2str(handles.counter));
 end



function GoToFrame_Callback(hObject, eventdata, handles)
% hObject    handle to GoToFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject,handles);
handles.counter = str2double(get(hObject,'String'));

if handles.counter < 1 && handles.counter > handles.Maxindex
    handles.counter = handles.counter + 1;
    msgbox('Wrong index')
else
    handles.Img=handles.rawEachFrame{handles.counter};
    handles.R=handles.Img;
    handles.G=handles.Img;
    handles.B=handles.Img;
%     handles.matFrame{handles.counter} =struct('PixelList',[]);
    guidata(hObject, handles);
    
    axes(handles.axes1);
    imshow(handles.rawEachFrame{handles.counter}); 
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
end
% Hints: get(hObject,'String') returns contents of GoToFrame as text
%        str2double(get(hObject,'String')) returns contents of GoToFrame as a double


% --- Executes during object creation, after setting all properties.
function GoToFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GoToFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

 
% --- Executes on button press in Mark.
function Mark_Callback(hObject, eventdata, handles)
% hObject    handle to Mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Dflag;
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=1;
    Dflag=0;
    set(handles.Delete,'Value',0);
elseif button_state==get(hObject,'Min')
    Aflag=0;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of Mark


% --- Executes on button press in Delete.
function Delete_Callback(hObject, eventdata, handles)
% hObject    handle to Delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Dflag;
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=0;
    Dflag=1;
    set(handles.Mark,'Value',0);
elseif button_state==get(hObject,'Min')
    Dflag=0;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of Delete


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Aflag Dflag flag;

Aflag = 0;
Dflag = 0;
flag = 0;
% Saveflag = 1;
% handles.PixelList = [];
handles.cmap=[1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;1,1,1];
guidata(hObject, handles);

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag;

handles = guidata(hObject);
cp = get(handles.axes1, 'CurrentPoint');
x = round(cp(1,1));
y = round(cp(1,2));

if(x>=1 && y>=1 && x<=handles.ydim && y<=handles.xdim)
    flag = 1;
    NewPixel = sub2ind(size(handles.Img),y,x);
    handles.NewPixel = NewPixel;
    handles.x = x;
    handles.y = y;
    guidata(hObject,handles);
else
    msgbox('Please choose pixels in figure')
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CLable Aflag Dflag flag;

NImg = zeros(handles.xdim,handles.ydim); 
if flag
    % retrieve the lastest handles
    handles = guidata(hObject);
    NImg(handles.NewPixel) = 1;
    R = round(get(handles.slider,'Value'))+1;
    se = strel('disk',R,0);
    NImg=imdilate(NImg,se);
    ind = find(NImg>0);
    % if Aflag && any(handles.matFrame{handles.counter}.PixelList(:))
    if Aflag && any(ismember(ind,handles.matFrame{handles.counter}))
        ind = setdiff(ind,handles.matFrame{handles.counter});
        %if overlap with previous points, then cut those part
    end
    [xx,yy] = ind2sub(size(NImg),ind);
    sub = [xx,yy];
    temp = repmat([handles.counter],length(ind),1);
    NewList = cat(2,sub,temp);
    
    
    if CLable<=handles.SetLable
        if Aflag
            handles=guidata(hObject);
            handles.lable_inx{CLable}.PixelList = cat(1,handles.lable_inx{CLable}.PixelList,NewList);
            guidata(hObject,handles);
            
            handles.R(ind)=handles.cmap(CLable,1);
            handles.G(ind)=handles.cmap(CLable,2);
            handles.B(ind)=handles.cmap(CLable,3);
            RGB=cat(3,handles.R,handles.G,handles.B);
            axes(handles.axes1);
            imshow(RGB);
            handles.RGB = RGB;
            handles.rawEachFrame{handles.counter} = RGB;
            guidata(hObject,handles);
            
            %         handles.matFrame{handles.counter}.figure(ind) = CLable;
            handles.matFrame{handles.counter} = cat(1,handles.matFrame{handles.counter},ind);
            guidata(hObject,handles);
            
        elseif Dflag
            r = handles.RGB(handles.y,handles.x,1);
            g = handles.RGB(handles.y,handles.x,2);
            b = handles.RGB(handles.y,handles.x,3);
            if r==handles.cmap(CLable,1)&&g==handles.cmap(CLable,2)&&b==handles.cmap(CLable,3)
                handles.lable_inx{CLable}.PixelList = setdiff(handles.lable_inx{CLable}.PixelList,NewList);
                guidata(hObject,handles);
                
                for i=1:1:length(ind)
                    value = handles.raw{handles.counter}(ind(i));
                    handles.R(ind(i))=value;
                    handles.G(ind(i))=value;
                    handles.B(ind(i))=value;
                    guidata(hObject,handles);
                end
                RGB=cat(3,handles.R,handles.G,handles.B);
                axes(handles.axes1);
                imshow(RGB);
                handles.RGB = RGB;
                handles.rawEachFrame{handles.counter} = RGB;
                
                handles.matFrame{handles.counter} = setdiff(handles.matFrame{handles.counter},ind);
                guidata(hObject,handles);
            else
                msgbox('Note: only to delete pixels on current lable')
            end
        end
    else
        msgbox('Notice: You current lable can not surpass your setting!')
    end
end
guidata(hObject, handles);


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=round(get(hObject,'Value')) + 1;
set(handles.edit3,'String',[num2str(x)]);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Are you sure to save the present LablePixelList? ', ...
	'Save', ...
	'Yes,please go on.','No, I will do some fixing.','No, I will do some fixing.');

switch choice
    case 'Yes,please go on.'
        handles=guidata(hObject);
        lable_index=handles.lable_inx;
        FileName = 'lable_index.mat';
        save(FileName,'lable_index');
        msgbox('save successfully','Infor');
        guidata(hObject, handles);
    case 'No, I will do some fixing.'
        return;
end

