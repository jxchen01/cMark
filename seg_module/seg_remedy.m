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

% Last Modified by GUIDE v2.5 17-Sep-2015 14:38:34

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
global Aflag Fflag Dflag Sflag
% Choose default command line output for seg_remedy
handles.output = hObject;

set(handles.slider, 'Max', 7,'Min',0);
set(handles.slider, 'SliderStep', [1/8 1]);
handles.Brush=1;

set(handles.Operation,'SelectedObject',handles.Add)
Aflag=1;
Fflag=0;
Dflag=0;
Sflag=0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes seg_remedy wait for user response (see UIRESUME)
% uiwait(handles.Fig_raw);

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

if ~isequal(FileName,0)
  
    load([PathName,FileName]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% prepare the variables, which will     %%%%%%%%%%%%%
    %%%%%%%%%%%%% be carried all around by handles      %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    handles = guidata(hObject);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% things will only be loaded once %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.cellEachFrame = cellEachFrame;
    handles.matEachFrame = matEachFrame;
    handles.rawEachFrame = rawEachFrame;
    
    %%%% build the color map %%%%
    est_cell=0;
    for i=1:1:numel(cellEachFrame)
        est_cell = max([est_cell, numel(cellEachFrame{i})]);
    end
    cmap=rand(ceil(est_cell*1.5),3);
    cmap=cmap*0.9; 
    cmap=cmap+0.1;
    cmap(1,:)=[0,0,0];    
    handles.cmap=cmap;
    
    %%%%%% other necessary information %%%%%%
    handles.Maxindex = numel(rawEachFrame);
    
    [dimx,dimy]=size(matEachFrame{1,1});
    handles.xdim = dimx;
    handles.ydim = dimy;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% things will be loaded each time going to a different frame %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.counter = 1;
    handles.Img = matEachFrame{1,1};
    handles.cList = cellEachFrame{1,1};
    handles.raw = rawEachFrame{1,1};
    
    set(handles.frame_idx,'String','1');
    set(handles.total_frame,'String',['/',num2str(handles.Maxindex)]);
    
    guidata(hObject, handles);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% visualization and trigger mouse gesture %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(handles.Fig_seg);
    imshow(handles.raw);
    hold on
    h=imshow(ind2rgb(matEachFrame{1,1},handles.cmap));
    hold off
    alpha=0.55.*ones(size(handles.Img));
    set(h,'AlphaData',alpha);
    set(gca,'NextPlot','add');   
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    clear h
    
    axes(handles.Fig_raw);
    imshow(rawEachFrame{1,1});
end


% --- Executes on button press in Goback.
function Goback_Callback(hObject, eventdata, handles)
% hObject    handle to Goback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Saveflag;
handles = guidata(hObject);

if(~isfield(handles,'Maxindex'))
    set(hObject,'String',[]);
    msgbox('lPlease load data first');
    return
end

if Saveflag==0
    choice = questdlg('Directly going back without "Save" will lose all modifications in the current frame. Continue?',...
	'Warning', ...
	'Yes','No','No');
% Handle response
   switch choice
    case 'Yes'
        nc = handles.counter - 1;
    case 'No'
        return;
   end
   Saveflag = 1;

else
    nc = handles.counter - 1;
end

if nc < 1
    msgbox('Already in the first frame')
else
    handles.counter = nc;
    handles.Img=handles.matEachFrame{1,nc};
    handles.cList=handles.cellEachFrame{1,nc};
    handles.raw = handles.rawEachFrame{1,nc};
    set(handles.frame_idx,'String',num2str(nc));
    guidata(hObject, handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% update the visualization %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(handles.Fig_seg);
    imshow(handles.raw);
    hold on
    h=imshow(ind2rgb(handles.Img,handles.cmap));
    hold off
    alpha=0.55.*ones(handles.xdim,handles.ydim);
    set(h,'AlphaData',alpha);
    set(gca,'NextPlot','add'); 
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    clear h
    
    axes(handles.Fig_raw);
    imshow(handles.raw);
end

% --- Executes on button press in Gonext.
function Gonext_Callback(hObject, eventdata, handles)
% hObject    handle to Gonext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Saveflag;
handles = guidata(hObject); 

if(~isfield(handles,'Maxindex'))
    set(hObject,'String',[]);
    msgbox('lPlease load data first');
    return
end

if Saveflag==0
    choice = questdlg('Directly going next without "Save" will lose all modifications in the current frame. Continue?',...
	'Warning', ...
	'Yes','No','No');
% Handle response
   switch choice
    case 'Yes'
        nc = handles.counter + 1;
    case 'No'
        return;
   end
   Saveflag = 1;
else
    nc = handles.counter + 1;
end

 if nc > handles.Maxindex
     msgbox('Already in the last frame') 
 else
     handles.counter = nc;
     handles.Img=handles.matEachFrame{1,nc};
     handles.cList=handles.cellEachFrame{1,nc};
     handles.raw = handles.rawEachFrame{1,nc};
     set(handles.frame_idx,'String',num2str(nc));
     guidata(hObject, handles);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%% update the visualization %%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     axes(handles.Fig_seg);
     imshow(handles.raw);
     hold on
     h=imshow(ind2rgb(handles.Img,handles.cmap));
     hold off
     alpha=0.55.*ones(handles.xdim,handles.ydim);
     set(h,'AlphaData',alpha);
     set(gca,'NextPlot','add');
     set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
     set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
     set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});   
     
     axes(handles.Fig_raw);
     imshow(handles.raw);
 end
 
 function frame_idx_Callback(hObject, eventdata, handles)
% hObject    handle to frame_idx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_idx as text
%        str2double(get(hObject,'String')) returns contents of frame_idx as a double
global Saveflag;
handles = guidata(hObject);

if(~isfield(handles,'Maxindex'))
    set(hObject,'String',[]);
    msgbox('lPlease load data first');
    return
end

if Saveflag==0
    choice = questdlg('Directly going the specific frame without "Save" will lose all modifications in the current frame. Continue?',...
	'Warning', ...
	'Yes','No','No');
% Handle response
   switch choice
    case 'Yes'
        nc = str2double(get(hObject,'String'));
    case 'No'
        return;
   end
   Saveflag = 1;
else
    nc = str2double(get(hObject,'String'));
end

if(nc>1 && nc<handles.Maxindex)
    handles.counter=nc;
    handles.Img=handles.matEachFrame{1,nc};
    handles.cList=handles.cellEachFrame{1,nc};
    handles.raw = handles.rawEachFrame{1,nc};
    guidata(hObject, handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% update the visualization %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(handles.Fig_seg);
    imshow(handles.raw);
    hold on
    h=imshow(ind2rgb(handles.Img,handles.cmap));
    hold off
    alpha=0.55.*ones(handles.xdim,handles.ydim);
    set(h,'AlphaData',alpha);
    set(gca,'NextPlot','add');
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    clear h
    
    axes(handles.Fig_raw);
    imshow(handles.raw);
else
    msgbox('Invalid Frame Index Number');
    set(hObject,'String',num2str(handles.counter))
end


% --- Executes during object creation, after setting all properties.
function Fig_seg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fig_seg (see GCBO)
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
% hObject    handle to Fig_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mflag x0 y0 x y Dflag Sflag value Fflag Aflag;

% retrieve the lastest handles 
handles = guidata(hObject);

cp = get(handles.Fig_seg, 'CurrentPoint');
x = round(cp(1,1));
y = round(cp(1,2));

if(x>=1 && y>=1 && x<=handles.ydim && y<=handles.xdim) % notice that x-y is reversed in plot
    value=handles.Img(y,x);
    if value==0 && Fflag
        msgbox('Not in the range of any cell body, please click again!')
    elseif(Aflag || Fflag || Sflag) 
        
        Mflag = 1;
        %%%%%% after button down, prepare necessary information for
        %%%%%% modification, including m and NImg,         
        NImg = zeros(handles.xdim,handles.ydim);
        NImg(y,x)=1;
        handles.NImg=NImg;
        guidata(hObject,handles);   
        
        %%%%%% real-time display according to different types of modification
        if Aflag
            plot(handles.Fig_seg, x, y, 'Color', 'r');
            drawnow
        elseif Fflag         
            plot(handles.Fig_seg, x, y, 'Color', 'w');
            drawnow   
        elseif Sflag
            plot(handles.Fig_seg, x, y, 'Color', 'k');
            drawnow;
        end
        
        x0 = x;
        y0 = y;
    elseif(Dflag)
        cImg = handles.Img;
        idx_rm = cImg(y,x);  
        if(idx_rm>0)
            max_id = numel(handles.cList);
            cList = handles.cList;
            cImg(ismember(cImg,idx_rm))=0;
            for i=idx_rm+1:1:max_id
                cImg(ismember(cImg,i))=i-1;
                cList{i-1}=cList{i};
            end
            cList(max_id)=[];
            handles.cList = cList;
            handles.Img = cImg;
            guidata(hObject, handles);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%% update visualization %%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            axes(handles.Fig_seg);
            imshow(handles.raw);
            hold on
            h=imshow(ind2rgb(cImg,handles.cmap));
            hold off
            alpha=0.55.*ones(handles.xdim,handles.ydim);
            set(h,'AlphaData',alpha);

            set(gca,'NextPlot','add');
            set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
            set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
            set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
            
            clear h
            
            axes(handles.Fig_raw);
            imshow(handles.raw);
        end
    end    
else
    Mflag=0;
end


% --- Executes on mouse motion over figure - except title and menu.
function figure2_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Fig_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mflag x0 y0 x y Aflag Fflag Sflag Saveflag; 

if Mflag
    %%%% set the current point as (x0,y0), preparing for following
    %%%% button motion drawing
    x0 = x;
    y0 = y;
    
    handles = guidata(hObject);
    
    cp = get(handles.Fig_seg, 'CurrentPoint');
    x = round(cp(1,1));
    y = round(cp(1,2));
    
    [xp, yp]=bresenham(x0,y0,x,y);
    if((~any(xp<1)) && (~any(xp>handles.ydim)) && (~any(yp<1)) &&(~any(yp>handles.xdim)))    
        % notice that x-y is reversed in plot 
        ind = sub2ind([handles.xdim,handles.ydim],yp,xp);

        LineWidthPlot = handles.Brush;
        if(handles.Brush>1)
            origInfo = getappdata(gca, 'matlab_graphics_resetplotview');
            %disp([get(gca,'XLim'),origInfo.XLim,get(gca,'YLim'),origInfo.YLim])
            if isempty(origInfo)
                isZoomed = false;
            elseif (isequal(get(gca,'XLim'), origInfo.XLim) && isequal(get(gca,'YLim'), origInfo.YLim) )      
                isZoomed = false;
            else
                isZoomed = true;
            end
            
            if(isZoomed)
                new_xx = get(gca,'XLim');
                %new_yy = get(gca,'YLim');
                %disp([(new_xx(2)-new_xx(1))/origInfo.XLim(2),(new_yy(2)-new_yy(1))/origInfo.YLim(2)])
                
                rr = origInfo.XLim(2)/(new_xx(2)-new_xx(1)) ;
                r0 = (handles.Brush-1)/2;
                
                r1 = min([handles.xdim / origInfo.YLim(2),handles.ydim / origInfo.XLim(2)]);
                LineWidthPlot= r0*rr*2 * r1 +1 ;
            end
        end
        
        handles.NImg(ind)=1;
        % NImg=zeros(handles.xdim,handles.ydim);
        % NImg(ind)=1;
        % se = strel('disk',LineWidth,0);
        % NImg=imdilate(NImg,se);
        % handles.NImg = handles.NImg | NImg;
        guidata(hObject, handles);
        
        if Aflag
            Saveflag = 0;
            plot(handles.Fig_seg, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', 'r');
            drawnow;
        elseif Fflag
            Saveflag = 0;
            plot(handles.Fig_seg, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', 'w');
            drawnow;         
        elseif Sflag
            Saveflag = 0;
            plot(handles.Fig_seg, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', 'k');
            drawnow;
        end
    end
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure2_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to Fig_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mflag Aflag Fflag value Sflag;

if Mflag %%%% only when A F S
    Mflag = 0;
    % retrieve the lastest handles
    handles = guidata(hObject);
    
    NImg = handles.NImg;
    if(handles.Brush>1) 
        se = strel('disk',(handles.Brush-1)/2,0);
        NImg=imdilate(NImg,se);
    end
    
    if Aflag  
        ind = find(NImg>0);
        tmp = handles.Img(ind);
        
        if(any(tmp(:)))
            waitfor(msgbox('New cell cannot overlap with existing cells'));
        else
            max_id = 1 + numel(handles.cList);
            handles.Img(ind)=max_id; % update matrix 
            handles.cList{1,max_id}=struct('seg',NImg,'size',numel(ind)); % update cell
        end
    elseif Fflag
        %Need User first choose the intend-to-fix cell, that's to say,
        %first buttondown on the specific cell
        if(value>0)
            ind = find(NImg>0);
            tmp = handles.Img(ind);
            if(any(tmp(:)>0 & tmp(:)~=value))
                waitfor(msgbox('Extended region cannot overlap with other existing cells'));
            else
                handles.Img(ind)=value;
                tmp = ismember(handles.Img,value);
                handles.cList{1,value}=struct('seg',tmp,'size',nnz(tmp));
            end
        end
        
    elseif Sflag
        cImg=handles.Img;
        cList=handles.cList;
        idx_modified = unique(nonzeros(cImg(NImg>0)));
        cImg(NImg>0)=0;
        
        empty_idx=[];
        max_id = numel(handles.cList);
        
        for i=1:1:numel(idx_modified)
            sRegion = ismember(cImg,idx_modified(i));
            cc = bwconncomp(sRegion);
            if(cc.NumObjects>0)
                % not wholly erased
                tmp=zeros(handles.xdim,handles.ydim);
                tmp(cc.PixelIdxList{1})=1; %%% the first component adopts the old index
                cList{idx_modified(i)} = struct('seg',tmp,'size',numel(cc.PixelIdxList{1}));
                
                if(cc.NumObjects>1) %%%% the remaining components will have new index
                    % region is broken
                    for j=2:1:cc.NumObjects
                        max_id = max_id+1;
                        % update mat
                        cImg(cc.PixelIdxList{j})=max_id;
                        % update cell
                        tmp=zeros(handles.xdim,handles.ydim);
                        tmp(cc.PixelIdxList{j})=1;
                        cList{max_id}=struct('seg',tmp,'size',numel(cc.PixelIdxList{j}));
                    end
                end
            else
                cList{idx_modified(i)}=[];
                empty_idx=cat(2,empty_idx,idx_modified(i));
            end
        end
        
        if(~isempty(empty_idx))
            for i=1:1:numel(empty_idx)
                idx_rm = empty_idx(i);
                cList(idx_rm)=[];
                for j=idx_rm+1:1:max_id
                    cImg(ismember(cImg,j))=j-1;
                end
                max_id = max_id - 1;
            end
        end
        
        handles.Img=cImg;
        handles.cList = cList;
    end
    
    axes(handles.Fig_seg);
    imshow(handles.raw);
    hold on
    h=imshow(ind2rgb(handles.Img,handles.cmap));
    hold off
    alpha=0.55.*ones(handles.xdim,handles.ydim);
    set(h,'AlphaData',alpha);
    set(gca,'NextPlot','add');
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    clear h
    
    axes(handles.Fig_raw);
    imshow(handles.raw);

    guidata(hObject, handles);
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
x=round(get(hObject,'Value'));
handles.Brush = 2*x+1;
set(handles.slider_value,'String',num2str(handles.Brush));
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on button press in SaveImage.
function SaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Saveflag;
handles = guidata(hObject);

if(~isfield(handles,'Maxindex'))
    set(hObject,'String',[]);
    msgbox('lPlease load data first');
    return
end

Saveflag = 1;
handles.matEachFrame{1,handles.counter}=handles.Img;
handles.cellEachFrame{1,handles.counter}=handles.cList;

guidata(hObject, handles);
msgbox('save successfully','Infor');


% --- Executes on button press in SaveAll.
function SaveAll_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);
if(~isfield(handles,'Maxindex'))
    set(hObject,'String',[]);
    msgbox('lPlease load data first');
    return
end


choice = questdlg('Save the current segmentation results?', 'Save', ...
	'Yes,please go on.','No, I will make more changes.','No, I will make more changes.');
% Handle response
switch choice
    case 'Yes,please go on.'
        [FileName,PathName] = uiputfile('*.mat','Select output location');
        handles = guidata(hObject);
%         load(handles.FileName);
        cellEachFrame = handles.cellEachFrame;
        matEachFrame = handles.matEachFrame;
        rawEachFrame = handles.rawEachFrame;
        save([PathName,FileName],'matEachFrame','rawEachFrame','cellEachFrame');
        msgbox('save successfully','Infor');
        guidata(hObject, handles);
    case 'No, I will make more changes.'
        return;
end

% --- Executes when selected object is changed in Operation.
function Operation_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Operation 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
gp=get(handles.Operation,'SelectedObject');
ts=get(gp,'Tag');
switch ts
    case 'Add'
        Aflag=1;
        Fflag=0;
        Dflag=0;
        Sflag=0;
    case 'Fix'
        Aflag=0;
        Fflag=1;
        Dflag=0;
        Sflag=0;       
    case 'Seperate'
        Aflag=0;
        Fflag=0;
        Dflag=0;
        Sflag=1;
    case 'Delete'
        Aflag=0;
        Fflag=0;
        Dflag=1;
        Sflag=0;
end
guidata(hObject, handles);
