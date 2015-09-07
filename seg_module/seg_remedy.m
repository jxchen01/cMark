 function varargout = seg_remedy(varargin)
%SEG_REMEDY M-file for seg_remedy.fig
%      SEG_REMEDY, by itself, creates a new SEG_REMEDY or raises the existing
%      singleton*.
%
%      H = SEG_REMEDY returns the handle to a new SEG_REMEDY or the handle to
%      the existing singleton*.
%
%      SEG_REMEDY('Property','Value',...) creates a new SEG_REMEDY using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to seg_remedy_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SEG_REMEDY('CALLBACK') and SEG_REMEDY('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SEG_REMEDY.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help seg_remedy

% Last Modified by GUIDE v2.5 16-Aug-2015 07:14:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seg_remedy_OpeningFcn, ...
                   'gui_OutputFcn',  @seg_remedy_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before seg_remedy is made visible.
function seg_remedy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for seg_remedy
handles.output = hObject;

% movegui(gcf, 'north');

set(handles.slider, 'Max', 10);
SliderStepX = 1/(10-0);
set(handles.slider, 'SliderStep', [SliderStepX 1]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes seg_remedy wait for user response (see UIRESUME)
% uiwait(handles.axes1);



% --- Outputs from this function are returned to the command line.
function varargout = seg_remedy_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in LoadOrgImg.
function LoadOrgImg_Callback(hObject, eventdata, handles)
% hObject    handle to LoadOrgImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile('*.mat','Select the MATLAB code file');

if isequal(FileName,0)
   msgbox('User selected Cancel');
else
    load(FileName);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% prepare the variables, which will     %%%%%%%%%%%%%
    %%%%%%%%%%%%% be carried all around by handles      %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cmap=rand(1000,3);
    cmap=cmap*0.9; 
    cmap=cmap+0.1;
    cmap(1,:)=[0,0,0];%Jianxu: set background as black, also increase the brightness 
    
    handles = guidata(hObject);
    handles.cellEachFrame = cellEachFrame;
    handles.matEachFrame = matEachFrame;
    handles.rawEachFrame = rawEachFrame;
    handles.FileName = FileName;
    
    handles.cmap=cmap;
    handles.Maxindex = numel(rawEachFrame);
    
    [dimx,dimy]=size(matEachFrame{1,1});
    handles.xdim = dimx;
    handles.ydim = dimy;
    
    handles.counter = 1;
    handles.Img = matEachFrame{1,1};
    handles.cList = cellEachFrame{1,1};
    guidata(hObject, handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% visualization and trigger mouse gesture %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(handles.axes2);
    imshow(matEachFrame{1,1},handles.cmap);
    set(gca,'NextPlot','add');
    freezeColors;
    
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    axes(handles.axes1);
    imshow(rawEachFrame{1,1});
end


% --- Executes on button press in Goback.
function Goback_Callback(hObject, eventdata, handles)
% hObject    handle to Goback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Saveflag;
handles = guidata(hObject);

if Saveflag==0
    choice = questdlg('Directly going back without Save will lose all the current work! Do you want to continue?',...
	'Warning', ...
	'Yes','No','No');
% Handle response
   switch choice
    case 'Yes'
        handles.counter = handles.counter - 1;
    case 'No'
        return;
   end
   Saveflag = 1;

else
    handles.counter = handles.counter - 1;
end

if handles.counter < 1
    handles.counter = handles.counter + 1;
    msgbox('Wrong index')
else
    handles.Img=handles.matEachFrame{1,handles.counter};
    handles.cList=handles.cellEachFrame{1,handles.counter};
    guidata(hObject, handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% update the visualization %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(handles.axes2);
    set(gca,'NextPlot','add');
    imshow(handles.matEachFrame{1,handles.counter},handles.cmap); 
    freezeColors;
    
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    axes(handles.axes1);
    imshow(handles.rawEachFrame{1,handles.counter});
end



% --- Executes on button press in Gonext.
function Gonext_Callback(hObject, eventdata, handles)
% hObject    handle to Gonext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Saveflag;
handles = guidata(hObject); 

if Saveflag==0
    choice = questdlg('Directly going next without Save will lose all the current work! Do you want to continue?',...
	'Warning', ...
	'Yes','No','No');
% Handle response
   switch choice
    case 'Yes'
        handles.counter = handles.counter + 1;
    case 'No'
        return;
   end
   Saveflag = 1;

else
    handles.counter = handles.counter + 1;
end

 if handles.counter > handles.Maxindex
     handles.counter = handles.counter - 1;
     msgbox('Wrong index') 
 else
     handles.Img=handles.matEachFrame{1,handles.counter};
     handles.cList=handles.cellEachFrame{1,handles.counter};
     guidata(hObject, handles);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%% update the visualization %%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     axes(handles.axes2);
     set(gca,'NextPlot','add');
     imshow(handles.matEachFrame{1,handles.counter},handles.cmap);
     freezeColors;
     
     set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
     set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
     set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});   
     
     axes(handles.axes1);
     imshow(handles.rawEachFrame{1,handles.counter});
 end

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Mflag Aflag Fflag Sflag Dflag Saveflag;
Mflag = 0;
% PaintFlag = 0;
% Eflag = 0;
Aflag = 0;
Fflag = 0;
Sflag = 0;
Dflag = 0;
Saveflag = 1;
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure2_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mflag x0 y0 x y Dflag Sflag value Fflag Aflag;

% retrieve the lastest handles 
handles = guidata(hObject);

cp = get(handles.axes2, 'CurrentPoint');
x = round(cp(1,1));
y = round(cp(1,2));

if(x>=1 && y>=1 && x<=handles.ydim && y<=handles.xdim) % notice that x-y is reversed in plot
    value=handles.Img(y,x);
    if value==0 && Fflag
        msgbox('Not in the range of cell, please choose again!')
    elseif(Aflag || Fflag || Dflag || Sflag) 
        
        Mflag = 1;
        %%%%%% after button down, prepare necessary information for
        %%%%%% modification, including m and NImg, 
        m=max(handles.Img(:));
        handles.m = m;
        
        NImg = zeros(handles.xdim,handles.ydim);
        NImg(y,x)=1;
        handles.NImg=NImg;
        guidata(hObject,handles);   
        %%%%%% real-time display according to different types of
        %%%%%% modification
        temp1=get(handles.Add,'Value');
        temp2=get(handles.Fix,'Value');
        
        if Aflag || Fflag
            if temp1==get(handles.Add,'Max')&&temp2==get(handles.Fix,'Min') % add new
                Color = handles.cmap(handles.m+1,:);
                plot(handles.axes2, x, y, 'Color', Color);
                drawnow
            elseif temp1==get(handles.Add,'Min')&&temp2==get(handles.Fix,'Max') % fix old
                Color = handles.cmap(value,:);
                plot(handles.axes2, x, y, 'Color', Color);
                drawnow
            end    
        elseif Dflag || Sflag
            plot(handles.axes2, x, y, 'Color', [0,0,0]);
            drawnow;
        end
    end
    x0 = x;
    y0 = y;
    guidata(hObject, handles);
else
    Mflag=0;
end


% --- Executes on mouse motion over figure - except title and menu.
function figure2_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mflag x0 y0 x y Aflag Fflag Dflag Sflag value Saveflag; 

if isMultipleCall();  
    return;  
end

if Mflag
    %%%% set the current point as (x0,y0), preparing for following
    %%%% button motion drawing
    x0 = x;
    y0 = y;
    
    handles = guidata(hObject);
    m=handles.m;
    
    cp = get(handles.axes2, 'CurrentPoint');
    x = round(cp(1,1));
    y = round(cp(1,2));
    
    %if(x>=1 && y>=1 && x<=handles.ydim && y<=handles.xdim) 
    
    [xp, yp]=bresenham(x0,y0,x,y);
    if((~any(xp<1)) && (~any(xp>handles.ydim)) && (~any(yp<1)) &&(~any(yp>handles.xdim)))    
        % notice that x-y is reversed in plot 
        
        ind = sub2ind([handles.xdim,handles.ydim],yp,xp);
        
        LineWidth = round(get(handles.slider, 'Value'))+1;
        LineWidthPlot = LineWidth + 2;
        
        temp1=get(handles.Add,'Value');
        temp2=get(handles.Fix,'Value');
        
        NImg=zeros(handles.xdim,handles.ydim);
        NImg(ind)=1;
        se = strel('disk',LineWidth,0);
        NImg=imdilate(NImg,se);
        
        guidata(hObject, handles);
        
        if Aflag || Fflag
            
            handles = guidata(hObject);
            
            if temp1==get(handles.Add,'Max')&&temp2==get(handles.Fix,'Min')
                Saveflag = 0;
                Color = handles.cmap(m+1,:);
                plot(handles.axes2, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', Color);
                drawnow;
            elseif temp1==get(handles.Add,'Min')&&temp2==get(handles.Fix,'Max')
                Saveflag = 0;
                Color = handles.cmap(value,:);
                plot(handles.axes2, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', Color);
                drawnow;
            end
        elseif Dflag || Sflag
            Saveflag = 0;
            plot(handles.axes2, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', [0,0,0]);
            drawnow;
        end
        handles.NImg = handles.NImg | NImg;
        guidata(hObject, handles);
    
    end
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure2_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mflag Aflag Fflag value Dflag Sflag;

if Mflag
    Mflag = 0;
    % retrieve the lastest handles
    handles = guidata(hObject);
    if Aflag
        handles.m=handles.m+1;
        handles.Img(handles.NImg>0)=handles.m;
        handles.cList{1,handles.m}=struct('seg',handles.NImg,'size',nnz(handles.NImg));
    elseif Fflag
        %Need User first choose the intend-to-fix cell, that's to say,
        %first buttondown on the specific cell
        if(value>0)
            handles.Img(handles.NImg>0)=value;
            handles.cList{1,value}=struct('seg',handles.NImg,'size',nnz(handles.NImg));
        end
    elseif Dflag
        %     Need to delete unit in cellEachFrame
        cImg=handles.Img;
        NImg=handles.NImg;
        idx_modified = unique(nonzeros(cImg(NImg>0)));
        cImg(NImg>0)=0;

        brokenFlag=0;
        for i=1:1:numel(idx_modified)
            sRegion = ismember(cImg,idx_modified(i));
            cc = bwconncomp(sRegion);
            if(cc.NumObjects>0)
                % not wholly erased
                handles.cList{idx_modified(i)} = struct('seg',sRegion,'size',nnz(sRegion));
                if(cc.NumObjects>1)
                    % region is broken
                    brokenFlag=1;
                end
            else
                handles.cList{idx_modified(i)}=[];
            end
        end
        
        handles.Img=cImg;
        guidata(hObject, handles);
        
        if(brokenFlag)
            msgbox('Just a reminder: You choose to remove noise or prune one cell, but at least one cell is broken');
        end
        
    elseif Sflag
        cImg=handles.Img;
        NImg=handles.NImg;
        idx_modified = unique(nonzeros(cImg(NImg>0)));
        cImg(NImg>0)=0;
        
        non_brokenFlag=0;
        for i=1:1:numel(idx_modified)
            sRegion = ismember(cImg,idx_modified(i));
            cc = bwconncomp(sRegion);
            if(cc.NumObjects>0)
                % not wholly erased
                tmp=zeros(handles.xdim,handles.ydim);
                tmp(cc.PixelIdxList{1})=1;
                handles.cList{idx_modified(i)} = struct('seg',tmp,'size',numel(cc.PixelIdxList{1}));
                
                if(cc.NumObjects>1)
                    % region is broken
                    max_id = handles.m;
                    for j=2:1:cc.NumObjects
                        max_id = max_id+1;
                        % update mat
                        cImg(cc.PixelIdxList{j})=max_id;
                        % update cell
                        tmp=zeros(handles.xdim,handles.ydim);
                        tmp(cc.PixelIdxList{j})=1;
                        handles.cList{max_id}=struct('seg',tmp,'size',numel(cc.PixelIdxList{j}));
                    end
                else
                    non_brokenFlag=1;
                end
            else
                non_brokenFlag=1;
                handles.cList{idx_modified(i)}=[];
            end
        end
        
        handles.Img=cImg;
        handles.m = max_id;
        guidata(hObject, handles);
        
        if(non_brokenFlag)
            msgbox('Just a reminder: You choose to cut cells, but at least one cell is only pruned instead of cutted');
        end
    end
    %handles = rmfield(handles,'NImg');
    guidata(hObject, handles);
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=round(get(hObject,'Value')) + 1;
set(handles.edit,'String',[num2str(x)]);
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


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Add.
function Add_Callback(hObject, eventdata, handles)
% hObject    handle to Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=1;
    Fflag=0;
    Dflag=0;
    Sflag=0;
    set(handles.Fix,'Value',0);
    set(handles.Separate,'Value',0);
    set(handles.DeleteNoise,'Value',0);
elseif button_state==get(hObject,'Min')
    Aflag=0;
    set(handles.Add,'Value',0);
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of Add


% --- Executes on button press in Fix.
function Fix_Callback(hObject, eventdata, handles)
% hObject    handle to Fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=0;
    Fflag=1;
    Dflag=0;
    Sflag=0;
    set(handles.Separate,'Value',0);
    set(handles.DeleteNoise,'Value',0);
    set(handles.Add,'Value',0);
elseif button_state==get(hObject,'Min')
    Fflag=0;
    set(handles.Fix,'Value',0);
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of Fix


% --- Executes on button press in DeleteNoise.
function DeleteNoise_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=0;
    Fflag=0;
    Dflag=1;
    Sflag=0;
    set(handles.Fix,'Value',0);
    set(handles.Separate,'Value',0);
    set(handles.Add,'Value',0);
elseif button_state==get(hObject,'Min')
    Dflag=0;
    set(handles.DeleteNoise,'Value',0);
end
guidata(hObject, handles);


% --- Executes on button press in Separate.
function Separate_Callback(hObject, eventdata, handles)
% hObject    handle to Separate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=0;
    Fflag=0;
    Dflag=0;
    Sflag=1;
    set(handles.Fix,'Value',0);
    set(handles.Add,'Value',0);
    set(handles.DeleteNoise,'Value',0);
elseif button_state==get(hObject,'Min')
    Sflag=0;
    set(handles.Separate,'Value',0);
end
guidata(hObject, handles);


function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit as text
%        str2double(get(hObject,'String')) returns contents of edit as a double


% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveImage.
function SaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Saveflag;
Saveflag = 1;
handles = guidata(hObject);

Img=handles.Img;
cList=handles.cList;

rm_idx=[];
for i=1:1:numel(cList)
    if(isempty(cList{i}))
        rm_idx=cat(1,rm_idx,i);
    end
end

if(isempty(rm_idx))
    handles.matEachFrame{1,handles.counter}=Img;
    handles.cellEachFrame{1,handles.counter}=cList;
else
    idx=setdiff(1:1:numel(cList),rm_idx);
    nList=cell(1,numel(idx));
    nList(:)=cList(idx);
    Img = zeros(handles.xdim,handles.ydim);
    for i=1:1:numel(idx)
        Img(nList{i}.seg)=i;
    end
    handles.matEachFrame{1,handles.counter}=Img;
    handles.cellEachFrame{1,handles.counter}=nList;
    handles.Img=Img;
    handles.cList = nList;
end

guidata(hObject, handles);

axes(handles.axes2);
set(gca,'NextPlot','add');
imshow(Img,handles.cmap);
freezeColors;

set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});

axes(handles.axes1);
imshow(handles.rawEachFrame{1,handles.counter});
     
msgbox('save successfully','Infor');


% --- Executes on button press in SaveAll.
function SaveAll_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Are you sure to save the present work? That will cover the original ones.', ...
	'Save', ...
	'Yes,please go on.','No, I will do some fixing.','No, I will do some fixing.');
% Handle response
switch choice
    case 'Yes,please go on.'
        handles = guidata(hObject);
%         load(handles.FileName);
        cellEachFrame = handles.cellEachFrame;
        matEachFrame = handles.matEachFrame;
        rawEachFrame = handles.rawEachFrame;
        save(handles.FileName,'matEachFrame','rawEachFrame','cellEachFrame');
        msgbox('save successfully','Infor');
        guidata(hObject, handles);
    case 'No, I will do some fixing.'
        return;
end
    


% --- Executes on button press in ShowLable.
function ShowLable_Callback(hObject, eventdata, handles)
% hObject    handle to ShowLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global value;

    set(handles.edit2,'String',[num2str(value)]);

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of ShowLable



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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
