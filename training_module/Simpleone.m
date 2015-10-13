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

% Last Modified by GUIDE v2.5 11-Oct-2015 10:13:45

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

global Aflag Dflag flag lock_up;

lock_up=0;

% Choose default command line output for Simpleone
handles.output = hObject;

set(handles.slider, 'Max', 7,'Min',0);
set(handles.slider, 'SliderStep', [1/8 1]);
handles.Brush=1;

% Update handles structure
guidata(hObject, handles);

Aflag=0;
flag=0;
Dflag=0;

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

%%%% after setting the number of labels, two variables will be created 
%%%% numLabel: the number of labels
%%%% label_idx: the list the pixels of each label

if(isfield(handles,'numLabel') && handles.numLabel>0)
    old_num = handles.numLabel;
    num=str2double(get(hObject,'String'));
    if(num<1 || num>7 || round(num)~=num)
        msgbox('Please enter a valid number: [0,1,2,3,4,5,6,7]');
        set(hObject,'String',num2str(old_num));
        return
    end
    
    tmp=handles.label_idx;
    if(old_num>num)
        handles.label_idx = cell(1,num);
        handles.label_idx(1:num) = tmp(1:num);
        handles.numLabel = num;
    elseif(old_num==num)
        return
    else
        handles.label_idx = cell(1,num);
        handles.label_idx(1:old_num) = tmp(1:old_num);
        for i=old_num+1:1:num
            handles.label_idx{i}=[];
        end
        handles.numLabel = num;
    end
else
    num=str2double(get(hObject,'String')); %%%% total number of labels
    if(num<1 || num>7 || round(num)~=num)
        msgbox('Please enter a valid number: [0,1,2,3,4,5,6,7]');
        set(hObject,'String',[]);
        return
    end
    handles.label_idx = cell(1,num);
    for i=1:1:num
        handles.label_idx{i} = [];
    end
    handles.numLabel = num;
end
guidata(hObject,handles);


function CurrentLable_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CLable;
handles=guidata(hObject);

if(~isfield(handles,'numLabel') || handles.numLabel<1)
    msgbox('set a valid number of labels first');
    set(hObject,'String',[]);
    return
end

tmp=str2double(get(hObject,'String'));
if (tmp<=handles.numLabel && tmp>0 && round(tmp)==tmp)
    CLable=tmp;
    switch CLable
        case 1
            set(handles.color,'String','Red');
        case 2
            set(handles.color,'String','Green');
        case 3
            set(handles.color,'String','Blue');
        case 4
            set(handles.color,'String','Yellow');
        case 5
            set(handles.color,'String','Magenta');
        case 6
            set(handles.color,'String','Cyan');
        case 7
            set(handles.color,'String','White');
    end
    guidata(hObject,handles);
else
    msgbox('Please enter a valid label');
end


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB code file');

if ~isequal(FileName,0)
    load([PathName,FileName],'rawEachFrame');
    handles = guidata(hObject);
    handles.raw = rawEachFrame;
    
    %%%%% general information %%%%%%
    handles.Maxindex = numel(rawEachFrame);
    [dimx,dimy]=size(rawEachFrame{1,1});
    handles.xdim = dimx;
    handles.ydim = dimy;
    
    %%%%% things will be changed each time going to a different frame %%%%
    handles.counter = 1;
    handles.Img = rawEachFrame{1,1};
    
    %%%% key variables %%%%%%
    handles.matFrame = cell(1,handles.Maxindex); %%%% each entry holds the indexed pixels in that frame
    for i=1:1:handles.Maxindex
        handles.matFrame{i}=zeros(dimx,dimy);
    end
    
    handles.rgb = cell(1,numel(rawEachFrame)); %%%% used to hold images with labels
    for i=1:1:numel(rawEachFrame)
        a=rawEachFrame{i};
        handles.rgb{i}=cat(3,a,a,a); %%% initially, no labels, only grayscale images
    end
    
    %%%% update text boxes %%%%%
    set(handles.GoToFrame,'String',num2str(handles.counter));
    set(handles.total_index,'String',['/',num2str(handles.Maxindex)]);
    
    guidata(hObject, handles);
    
    %%%%%%%%% visualization %%%%%%%%
    axes(handles.fig);
    imshow(rawEachFrame{1,1});
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure1_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
end
    

% --- Executes on button press in goback.
function goback_Callback(hObject, eventdata, handles)
% hObject    handle to goback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

if(~isfield(handles,'Maxindex'))
    return
end

if handles.counter == 1
    msgbox('Already in the first frame!')
else
    handles.counter = handles.counter - 1;
    handles.Img=handles.raw{1,handles.counter}; %%%% the orginal grayscale image
    guidata(hObject, handles);
    
    axes(handles.fig);
    imshow(handles.rgb{handles.counter}); 
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure1_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
    set(handles.GoToFrame,'String',num2str(handles.counter));
end


% --- Executes on button press in gonext.
function gonext_Callback(hObject, eventdata, handles)
% hObject    handle to gonext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);
if(~isfield(handles,'Maxindex'))
    return
end

if handles.counter == handles.Maxindex
    msgbox('Already in the last frame')
else
    handles.counter = handles.counter + 1;
    handles.Img=handles.raw{handles.counter};
    guidata(hObject, handles);
    
    axes(handles.fig);
    imshow(handles.rgb{handles.counter});
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure1_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
    set(handles.GoToFrame,'String',num2str(handles.counter));
end


function GoToFrame_Callback(hObject, eventdata, handles)
% hObject    handle to GoToFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
if(~isfield(handles,'Maxindex'))
    set(hObject,'String',[]);
    msgbox('lPlease load data first');
    return
end

f_idx = str2double(get(hObject,'String'));

if (f_idx < 1 || f_idx > handles.Maxindex || round(f_idx)~=f_idx)
    msgbox('Invalid Frame Index Number')
    set(hObject,'String',num2str(handles.counter));
else
    handles.counter = f_idx;
    handles.Img=handles.raw{handles.counter};
    guidata(hObject, handles);
    
    axes(handles.fig);
    imshow(handles.rgb{handles.counter}); 
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure1_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
end


% --- Executes on button press in Mark.
function Mark_Callback(hObject, eventdata, handles)
% hObject    handle to Mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Dflag;

handles=guidata(hObject);
if(~isfield(handles,'numLabel') || handles.numLabel<1)
    msgbox('Please set a valid number of labels first');
    set(handles.Mark,'Value',0);
    return
end

if(~isfield(handles,'Maxindex'))
    msgbox('load data first');
    set(handles.Mark,'Value',0);
    return
end

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

handles=guidata(hObject);
if(~isfield(handles,'numLabel') || handles.numLabel<=0)
    msgbox('set a valid number of labels first');
    set(handles.Delete,'Value',0);
    return
end

if(~isfield(handles,'Maxindex'))
    msgbox('load data first');
    set(handles.Delete,'Value',0);
    return
end

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
function fig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Aflag Dflag flag;

Aflag = 0;
Dflag = 0;
flag = 0;
handles.cmap=[1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;1,1,1];
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag Aflag Dflag x y lock_up;

if(~lock_up)

    if(Aflag || Dflag)
        handles = guidata(hObject);
        cp = get(handles.fig, 'CurrentPoint');
        x = round(cp(1,1));
        y = round(cp(1,2));
        
        if(x>=1 && y>=1 && x<=handles.ydim && y<=handles.xdim)
            flag = 1;
            NewPixel = sub2ind(size(handles.Img),y,x);
            handles.NewPixel = NewPixel;
            NImg=zeros(handles.xdim,handles.ydim);
            NImg(y,x)=1;
            handles.NImg = NImg;
            guidata(hObject,handles);
        end
    end

end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Fig_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag flag Dflag CLable x0 y0 x y; 

if flag
    %%%% set the current point as (x0,y0), preparing for following
    %%%% button motion drawing
    x0 = x;
    y0 = y;
    
    handles = guidata(hObject);
    
    cp = get(handles.fig, 'CurrentPoint');
    x = round(cp(1,1));
    y = round(cp(1,2));

    [xp, yp]=bresenham(x0,y0,x,y);
    if((~any(xp<1)) && (~any(xp>handles.ydim)) && (~any(yp<1)) &&(~any(yp>handles.xdim)))    
        % notice that x-y is reversed in plot 
        ind = sub2ind([handles.xdim,handles.ydim],yp,xp);
        
        LineWidthPlot=handles.Brush;

        NImg = handles.NImg;
        NImg(ind)=1;
        handles.NImg = handles.NImg | NImg;
        guidata(hObject, handles);
        
        if Aflag
            Color = handles.cmap(CLable,:);
            plot(handles.fig, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', Color);
            drawnow;
        elseif Dflag
            Color = [0,0,0];
            plot(handles.fig, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', Color);
            drawnow;         
        end
    end
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CLable Aflag Dflag flag lock_up;

if flag
    flag=0;
    lock_up=1;
    % retrieve the lastest handles
    handles = guidata(hObject);
    NImg = handles.NImg;
    if(handles.Brush>1) 
        se = strel('disk',(handles.Brush-1)/2,0);
        NImg=imdilate(NImg,se);
    end
    
    ind = find(NImg>0);
    
    labelMat = handles.matFrame{handles.counter};
    if Aflag && any(ismember(ind,labelMat>0))
        ind = setdiff(ind,labelMat>0);
        %if overlap with previous points, then exclude those pixels
    end
    
    [xx,yy] = ind2sub([handles.xdim,handles.ydim],ind);
    sub = [xx,yy];
    temp = repmat([handles.counter],length(ind),1);
    NewList = cat(2,sub,temp);

    if Aflag
        handles.label_idx{CLable} = cat(1,handles.label_idx{CLable},NewList);
        
        rgb=handles.rgb{handles.counter};
        r=rgb(:,:,1); r(ind)=handles.cmap(CLable,1);
        g=rgb(:,:,2); g(ind)=handles.cmap(CLable,2);
        b=rgb(:,:,3); b(ind)=handles.cmap(CLable,3);   
        rgb=cat(3,r,g,b);
        handles.rgb{handles.counter} = rgb;
        
        labelMat(ind)=CLable;
        handles.matFrame{handles.counter} = labelMat;
    elseif Dflag
        rgb = handles.rgb{handles.counter};
        r = rgb(:,:,1);
        g = rgb(:,:,2);
        b = rgb(:,:,3);
        
        for i=1:1:numel(ind)
            c_idx = labelMat(ind(i));
            if(c_idx>0) %%%% need to be removed
                %%%% update labelMat
                labelMat(ind(i))=0;
                %%%% update rgb
                value = handles.raw{handles.counter}(ind(i));
                r(ind(i))=value;
                g(ind(i))=value;
                b(ind(i))=value;
                %%%% update pixel list
                pixel_idx = handles.label_idx{c_idx};
                ind1=find(pixel_idx(:,3)==handles.counter);
                pixel_idx1=pixel_idx(ind1,:);
                ind2=find(pixel_idx1(:,2)==yy(i));
                pixel_idx2=pixel_idx1(ind2,:);
                ind3=find(pixel_idx2(:,1)==xx(i));
                if(~isempty(ind3))
                    pixel_idx(ind1(ind2(ind3)),:)=[];
                    handles.label_idx{c_idx} = pixel_idx;
                    clear pixel_idx pixel_idx1 pixel_idx2 ind1 ind2 ind3
                else
                    error('did not find');
                end
            end
        end
        rgb=cat(3,r,g,b);
        handles.rgb{handles.counter}=rgb;
        handles.matFrame{handles.counter}=labelMat;        
    end
    guidata(hObject,handles);
    
    axes(handles.fig);
    imshow(rgb);
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure1_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
    
    lock_up=0;
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
x=round(get(hObject,'Value'));
handles.Brush = 2*x+1;
set(handles.edit3,'String',num2str(handles.Brush));
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(hObject);
if(~isfield(handles,'Maxindex') || ~isfield(handles,'label_idx'))
    return
end

emptyFlag=1;
for i=1:1:handles.numLabel
    if(~isempty(handles.label_idx{i}))
        emptyFlag=0;
        break;
    end
end

if(emptyFlag)
    msgbox('No annotation has been made. No need to save');
    return
end

choice = questdlg('Are you sure to save the present LablePixelList? ', ...
	'Save', ...
	'Yes','No, I will make more changes.','No, I will make more changes.');

switch choice
    case 'Yes'
        [FileName,PathName] = uiputfile('*.mat','Select output location');
        label_index=handles.label_idx;
        save([PathName,FileName],'label_index');
        guidata(hObject, handles);
        msgbox('save successfully','Infor');
    case 'No, I will make more changes.'
        return;
end


% --- Executes on button press in load_labels.
function load_labels_Callback(hObject, eventdata, handles)
% hObject    handle to load_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if(~isfield(handles,'Maxindex'))
    msgbox('Load Data First');
    return
end

[FileName,PathName] = uigetfile('*.mat','Select the MATLAB code file');

if ~isequal(FileName,0)
    S=load([PathName,FileName]);
    if(~isfield(S,'label_index'))
        msgbox('Pre-label should contain a variable named **label_index**.');
        return
    end
    label_index = S.label_index;
    handles.label_idx = label_index;
    %%%%% update rgb (label) information of each pixel %%%%%%
    num=numel(label_index);
    handles.numLabel = num;
    
    for i=1:1:num
        lab=label_index{i};
        for j=1:1:numel(lab)/3
            fid=lab(j,3);
            if(fid<0 || fid>handles.Maxindex || lab(j,1)<0 || lab(j,2)<0 || lab(j,1)>handles.xdim || lab(j,2)>handles.ydim)
                msgbox('Labels are not compatiable with current data' );
                error('error occurs when loading pre-labels');
            end
            rgb=handles.rgb{fid};
            rgb(lab(j,1),lab(j,2),:) = handles.cmap(i,:);
            handles.rgb{fid} = rgb;
        end
    end 
    guidata(hObject, handles);    
    set(handles.SetLable,'String',num2str(num));

    %%%% updatae visualization %%%%
    axes(handles.fig);
    imshow(handles.rgb{handles.counter}); 
    
    set(gcf,'WindowButtonDownFcn',{@figure1_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure1_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure1_WindowButtonUpFcn,handles});
end
