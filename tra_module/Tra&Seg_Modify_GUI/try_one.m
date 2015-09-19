function varargout = try_one(varargin)
% TRY_ONE MATLAB code for try_one.fig
%      TRY_ONE, by itself, creates a new TRY_ONE or raises the existing
%      singleton*.
%
%      H = TRY_ONE returns the handle to a new TRY_ONE or the handle to
%      the existing singleton*.
%
%      TRY_ONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRY_ONE.M with the given input arguments.
%
%      TRY_ONE('Property','Value',...) creates a new TRY_ONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before try_one_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to try_one_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help try_one

% Last Modified by GUIDE v2.5 18-Sep-2015 22:31:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @try_one_OpeningFcn, ...
                   'gui_OutputFcn',  @try_one_OutputFcn, ...
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


% --- Executes just before try_one is made visible.
function try_one_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to try_one (see VARARGIN)

% Choose default command line output for try_one
handles.output = hObject;

% set the slider's parameters
set(handles.slider2, 'Max', 10);
SliderStepX = 1/(10-0);
set(handles.slider2, 'SliderStep', [SliderStepX 1]);

% size of window
set(handles.uipanel2,'unit','normalized','position',[0.01,0.01,0.99,0.99]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes try_one wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = try_one_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Mflag Aflag Fflag Sflag Dflag Saveflag;
Mflag = 0;
Aflag = 0;
Fflag = 0;
Sflag = 0;
Dflag = 0;
Saveflag = 1;
guidata(hObject, handles);
% Hint: place code in OpeningFcn to populate axes2


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Display. %%% load data
function Display_Callback(hObject, eventdata, handles)
% hObject    handle to Display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB code file');
if isequal(FileName,0)
   return
else
   handles = guidata(hObject);
   load([PathName,FileName]);

   %%%% data variables %%%%
   handles.cellEachFrame = cellEachFrame;
   handles.idEachFrame = idEachFrame;
   handles.matEachFrame = matEachFrame;
   handles.rawEachFrame = rawEachFrame;
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%% key variables for the whole program %%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   handles.FileName = [PathName,FileName];
   handles.action = 0;
   handles.action2 = 0;
   handles.autosave = 0;
   handles.certaincell = 0;
   handles.certainidx = 1;
   
   [dimx,dimy]=size(matEachFrame{1,2});
   handles.xdim = dimx;
   handles.ydim = dimy;
   
   handles.Maxindex = numel(rawEachFrame); % max frame index
   handles.Max = 0; % max id
   for i = 1:handles.Maxindex
       Max = max(idEachFrame{1, i}(:));
       if Max > handles.Max
          handles.Max = Max;
       end
   end
   
   % build color map 
   cmap=rand(ceil(handles.Max*1.5),3);
   cmap=cmap*0.9;
   cmap=cmap+0.1;
   cmap(1,:)=[0,0,0];
   handles.colormap=cmap;
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%% set the initial two frames %%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   handles.counter1 = 1;
   handles.counter2 = 2;
   
   handles.Img = matEachFrame{1,2};
   handles.idImg = idEachFrame{1,2};
   handles.cList = cellEachFrame{1,2};
    
   axes(handles.axes1);
   imshow(ind2rgb(handles.idEachFrame{1,handles.counter1} + 1,handles.colormap));
   
   axes(handles.axes2);
   imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1,handles.colormap));
   set(gca,'NextPlot','replace');

   set(handles.GotoFrame,'String',num2str(handles.counter1));
   set(handles.GotoFrame2,'String',num2str(handles.counter2));
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%% set up the window for potential segmentation correction %%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % let the user be able to draw on the image
   set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
   set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
   set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
   
   guidata(hObject, handles);
end


% % --- Executes on button press in Gocertain.
% function Gocertain_Callback(hObject, eventdata, handles)
% % hObject    handle to Gocertain (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% handles = guidata(hObject);
% % display a certain cell's trajectory
% if handles.certaincell == 1
%     tempidEachFrame = handles.idEachFrame;
%     temp = ismember(tempidEachFrame{1, handles.counter1},handles.certainidx);  % select the certain cell's area
%     mat = tempidEachFrame{1, handles.counter1}; 
%     mat(mat>0) = handles.whitecolor;  % set the color of other cells white
%     mat(temp>0) = handles.certainidx;  % give the certain cell a certain color
%     tempidEachFrame{1, handles.counter1} = mat;  % updated matrix
%     axes(handles.axes1);
%     imshow(tempidEachFrame{1,handles.counter1} + 1,handles.colormap);
% end
% guidata(hObject, handles);


% --- Executes on button press in Certaincell.
function Certaincell_Callback(hObject, eventdata, handles)
% hObject    handle to Certaincell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Certaincell
handles = guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end

val = get(hObject,'Value');
if val == 1
    handles.certaincell = 1;
else
    handles.certaincell = 0;
end
guidata(hObject, handles);


function Certainidx_Callback(hObject, eventdata, handles)
% hObject    handle to Certainidx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Certainidx as text
%        str2double(get(hObject,'String')) returns contents of Certainidx as a double
handles = guidata(hObject);
if(handles.certaincell==0)
    msgbox('Not in the single trajectory display mode');
    return
end

if(~isfield(handles,'FileName'))
    return
end

val = str2double(get(hObject,'String'));
if val < 1 || val > handles.Max
    msgbox(['Invalid trajecotry index, the max value is ',num2str(handles.Max)],'Error','error');
else
    handles.certainidx = val;
    guidata(hObject, handles);
end


% --- Executes on button press in Gonext.
function Gonext_Callback(hObject, eventdata, handles)
% hObject    handle to Gonext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject); 
if(~isfield(handles,'FileName'))
    return
end

if handles.counter1 == handles.Maxindex
    msgbox('Already in the last frame','Error','error');
else
    handles.counter1 = handles.counter1 + 1;
    set(handles.Preid,'String',[]);
    set(handles.Prechild,'String',[]);
    set(handles.Preparent,'String',[]);
    handles.action = 0;
    if handles.certaincell == 1
        tempidEachFrame = handles.idEachFrame;
        temp = ismember(tempidEachFrame{1, handles.counter1},handles.certainidx);
        zz=zeros(handles.xdim,handles.ydim);
        axes(handles.axes1);
        imshow(cat(3,temp,zz,zz));
    else
        axes(handles.axes1);
        imshow(ind2rgb(handles.idEachFrame{1,handles.counter1} + 1, handles.colormap));
    end
    Str=num2str(handles.counter1);
    set(handles.GotoFrame,'String',Str);
    guidata(hObject, handles);
end

% --- Executes on button press in Goback.
function Goback_Callback(hObject, eventdata, handles)
% hObject    handle to Goback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end

if handles.counter1 == 1
    msgbox('Already in the first frame','Error','error') 
else
    handles.counter1 = handles.counter1 - 1;
    Emstr = ''; 
    set(handles.Preid,'String',Emstr);
    set(handles.Prechild,'String',Emstr);
    set(handles.Preparent,'String',Emstr);
    handles.action = 0;
    if handles.certaincell == 1
        tempidEachFrame = handles.idEachFrame;
        temp = ismember(tempidEachFrame{1, handles.counter1},handles.certainidx);
        zz=zeros(handles.xdim,handles.ydim);
        axes(handles.axes1);
        imshow(cat(3,temp,zz,zz));
    else    
        axes(handles.axes1);
        imshow(handles.idEachFrame{1,handles.counter1} + 1, handles.colormap);
    end
    Str=num2str(handles.counter1);
    set(handles.GotoFrame,'String',Str);
    guidata(hObject, handles);
end


function GotoFrame_Callback(hObject, eventdata, handles)
% hObject    handle to GotoFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoFrame as text
%        str2double(get(hObject,'String')) returns contents of GotoFrame as a double
handles = guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end

% get the index of a certain frame
val = get(hObject, 'String');
idxFrame = str2double(val);
if idxFrame < 1 || idxFrame > handles.Maxindex
    msgbox(['Invalide index, the max index value is ',num2str(handles.Maxindex)],'Error','error');
else
    handles.counter1 = idxFrame;
    
    axes(handles.axes1);
    set(handles.Preid,'String',[]);
    set(handles.Prechild,'String',[]);
    set(handles.Preparent,'String',[]);
    handles.action = 0;
    if handles.certaincell == 1
        tempidEachFrame = handles.idEachFrame;
        temp = ismember(tempidEachFrame{1, handles.counter1},handles.certainidx);
        zz=zeros(handles.xdim,handles.ydim);
        axes(handles.axes1);
        imshow(cat(3,temp,zz,zz));
    else
        imshow(ind2rgb(handles.idEachFrame{1,handles.counter1} + 1,handles.colormap));
    end
    guidata(hObject, handles);
end


% --- Executes on button press in Gonext2.
function Gonext2_Callback(hObject, eventdata, handles)
% hObject    handle to Gonext2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject); 
if(~isfield(handles,'FileName'))
    return
end

if handles.counter2 == handles.Maxindex
    msgbox('Already in the last frame','Error','error')
else
    handles.action2 = 0;
    handles.counter2 = handles.counter2 + 1;
    set(handles.Postid,'String',[]);
    set(handles.Postchild,'String',[]);
    set(handles.Postparent,'String',[]);
    set(handles.GotoFrame2,'String',num2str(handles.counter2));
    
    %%%% update visualization %%%%
    axes(handles.axes2);
    set(gca,'NextPlot','replace');
    imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1, handles.colormap));
 
    %%%% prepare for segmentation correction
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    handles.Img=handles.matEachFrame{1,handles.counter2};
    handles.idImg = handles.idEachFrame{1,handles.counter2};
    handles.cList=handles.cellEachFrame{1,handles.counter2};
    
    guidata(hObject, handles);
end


% --- Executes on button press in Goback2.
function Goback2_Callback(hObject, eventdata, handles)
% hObject    handle to Goback2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if handles.counter2 == 1
    msgbox('Already in the first frame','Error','error') 
else
    handles.action2 = 0;
    handles.counter2 = handles.counter2 - 1;
    set(handles.Postid,'String',[]);
    set(handles.Postchild,'String',[]);
    set(handles.Postparent,'String',[]);
    set(handles.GotoFrame2,'String',num2str(handles.counter2));
    
    %%%%% update visualization %%%%
    axes(handles.axes2);
    set(gca,'NextPlot','replace');
    imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1, handles.colormap));

    %%%%% prepare for segmentation correction %%%%%
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});  
    
    handles.Img=handles.matEachFrame{1,handles.counter2};
    handles.idImg = handles.idEachFrame{1, handles.counter2};
    handles.cList=handles.cellEachFrame{1,handles.counter2};
    
    guidata(hObject, handles);
end


function GotoFrame2_Callback(hObject, eventdata, handles)
% hObject    handle to GotoFrame2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoFrame2 as text
%        str2double(get(hObject,'String')) returns contents of GotoFrame2 as a double
handles = guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end

% get the index of a certain frame
val = get(hObject, 'String');
idxFrame = str2double(val);
if idxFrame < 1 || idxFrame > handles.Maxindex
    msgbox(['Invalide index, the max index value is ',num2str(handles.Maxindex)],'Error','error');
else
    handles.action2 = 0;
    handles.counter2 = idxFrame;
    set(handles.Postid,'String',[]);
    set(handles.Postchild,'String',[]);
    set(handles.Postparent,'String',[]);
    
    axes(handles.axes2);
    set(gca,'NextPlot','replace');
    imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1,handles.colormap));
 
    %%%% prepare for segmentation correction %%%%
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});

    handles.Img=handles.matEachFrame{1,handles.counter2};
    handles.idImg = handles.idEachFrame{1, handles.counter2};
    handles.cList=handles.cellEachFrame{1,handles.counter2};
    guidata(hObject, handles);
end



% --- Executes on button press in RawIm.
function RawIm_Callback(hObject, eventdata, handles)
% hObject    handle to RawIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% display the raw image
axes(handles.axes1);
str = ['Frame ',num2str(handles.counter1)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Grey plus RGB image %%%%%%%%%%%%%%%%
rawimage = handles.rawEachFrame{1, handles.counter1};
idimage = handles.idEachFrame{1, handles.counter1};
colormap = handles.colormap;
colormap(1,:) = 1;
[M, N] = size(rawimage);
rgb = zeros(M,N,3);
for i=1:M
    for j=1:N
        if(idimage(i,j)>0)
            % convert index color into true color image (RGB)
            rgb(i,j,:) = colormap(idimage(i,j) + 1,:);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(handles.counter1),
imshow(rawimage);
hold on
h = imshow(rgb);
hold off
alpha=0.5.*ones(M, N);
set(h,'AlphaData',alpha);
set(figure(handles.counter1),'NumberTitle','off','Name',str) ; 
guidata(hObject, handles);


% --- Executes on button press in RawIm2.
function RawIm2_Callback(hObject, eventdata, handles)
% hObject    handle to RawIm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% display the raw image
axes(handles.axes2);
str = ['Frame ',num2str(handles.counter2)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Grey plus RGB image %%%%%%%%%%%%%%%%
rawimage = handles.rawEachFrame{1, handles.counter2};
idimage = handles.idEachFrame{1, handles.counter2};
[M, N] = size(rawimage);
rgb = zeros(M,N,3);
for i=1:M
    for j=1:N
        if(idimage(i,j)>0)
            % convert index color into true color image (RGB)
            rgb(i,j,:) = handles.colormap(idimage(i,j) + 1,:);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(handles.counter2),
imshow(rawimage);
hold on
h = imshow(rgb);
hold off
alpha=0.5.*ones(M, N);
set(h,'AlphaData',alpha);
set(figure(handles.counter2),'NumberTitle','off','Name',str) ; 
guidata(hObject, handles);



% Modify segmentation
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
        temp1=get(handles.Seg_Add,'Value');
        temp2=get(handles.Seg_Fix,'Value');
        
        if Aflag || Fflag
            if temp1==get(handles.Seg_Add,'Max')&&temp2==get(handles.Seg_Fix,'Min') % add new
                Color = handles.colormap(handles.m+1,:);
                plot(handles.axes2, x, y, 'Color', Color);
                drawnow
            elseif temp1==get(handles.Seg_Add,'Min')&&temp2==get(handles.Seg_Fix,'Max') % fix old
                Color = handles.colormap(value,:);
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
        
        LineWidth = round(get(handles.slider2, 'Value'))+1;
        LineWidthPlot = LineWidth + 2;
        
        temp1=get(handles.Seg_Add,'Value');
        temp2=get(handles.Seg_Fix,'Value');
        
        NImg=zeros(handles.xdim,handles.ydim);
        NImg(ind)=1;
        se = strel('disk',LineWidth,0);
        NImg=imdilate(NImg,se);
        
        guidata(hObject, handles);
        
        if Aflag || Fflag
            
            handles = guidata(hObject);
            
            if temp1==get(handles.Seg_Add,'Max')&&temp2==get(handles.Seg_Fix,'Min')
                Saveflag = 0;
                Color = handles.colormap(m+1,:);
                plot(handles.axes2, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', Color);
                drawnow;
            elseif temp1==get(handles.Seg_Add,'Min')&&temp2==get(handles.Seg_Fix,'Max')
                Saveflag = 0;
                Color = handles.colormap(value,:);
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
        newidx = handles.Max + 1;
        handles.Max = newidx;
        handles.idImg(handles.NImg>0)=handles.Max;
        handles.cList{1,handles.m}=struct('seg',handles.NImg,'size',nnz(handles.NImg),'child',[],'parent',[],'id',handles.Max);
    elseif Fflag
        %Need User first choose the intend-to-fix cell, that's to say,
        %first buttondown on the specific cell
        if(value>0)
            handles.Img(handles.NImg>0)=value;
            child=handles.cList{1,value}.child;
            parent=handles.cList{1,value}.parent;
            id=handles.cList{1,value}.id;
            handles.idImg(handles.NImg>0)=id;
            handles.cList{1,value}=struct('seg',handles.NImg,'size',nnz(handles.NImg),'child',child,'parent',parent,'id',id);
        end
    elseif Dflag
        %     Need to delete unit in cellEachFrame
        cImg=handles.Img;
        idImg=handles.idImg;
        NImg=handles.NImg;
        idx_modified = unique(nonzeros(cImg(NImg>0)));
        cImg(NImg>0)=0;
        idImg(NImg>0)=0;

        brokenFlag=0;
        for i=1:1:numel(idx_modified)
            sRegion = ismember(cImg,idx_modified(i));
            cc = bwconncomp(sRegion);
            if(cc.NumObjects>0)
                % not wholly erased
                child=handles.cList{idx_modified(i)}.child;
                parent=handles.cList{idx_modified(i)}.parent;
                id=handles.cList{idx_modified(i)}.id;
                handles.cList{idx_modified(i)} = struct('seg',sRegion,'size',nnz(sRegion),'child',child,'parent',parent,'id',id);
                if(cc.NumObjects>1)
                    % region is broken
                    brokenFlag=1;
                end
            else
                % delete from its parent's child
                LastParent = handles.cList{idx_modified(i)}.parent;
                LPSiz = size(LastParent);
                handles.LPSiz = LPSiz(1);
                if isempty(LastParent)
                    disp('No parent');
                else
                    for l = 1:handles.LPSiz
                        C = handles.cellEachFrame{1, LastParent(l,1)}{1, LastParent(l,2)}.child;
                        Cindex = C(:,2) >= idx_modified(i) & C(:,2) <= idx_modified(i);
                        C(Cindex,:) = [];
                        C = [C;handles.cList{idx_modified(i)}.child];                     
                        handles.cellEachFrame{1, LastParent(l,1)}{1, LastParent(l,2)}.child = C;
                    end
                end
                % delete from its child's parent
                FirstChild = handles.cList{idx_modified(i)}.child;
                FCSiz = size(FirstChild);
                handles.FCSiz = FCSiz(1);
                if isempty(FirstChild)
                    disp('No child');
                else
                    for l = 1:handles.FCSiz
                        P = handles.cellEachFrame{1, FirstChild(l,1)}{1, FirstChild(l,2)}.parent;
                        Pindex = P(:,2) >= idx_modified(i) & P(:,2) <= idx_modified(i);
                        P(Pindex,:) = [];
                        P = [P;handles.cList{idx_modified(i)}.parent];
                        handles.cellEachFrame{1, FirstChild(l,1)}{1, FirstChild(l,2)}.parent = P;
                    end
                end
                %update the cell
                handles.cList{idx_modified(i)}=[];                
            end
        end
        
        handles.Img=cImg;
        handles.idImg=idImg;
        guidata(hObject, handles);
        
        if(brokenFlag)
            msgbox('Just a reminder: You choose to remove noise or prune one cell, but at least one cell is broken');
        end
        
    elseif Sflag
        cImg=handles.Img;
        idImg=handles.idImg;
        NImg=handles.NImg;
        idx_modified = unique(nonzeros(cImg(NImg>0)));
        cImg(NImg>0)=0;
        idImg(NImg>0)=0;
        
        non_brokenFlag=0;
        for i=1:1:numel(idx_modified)
            sRegion = ismember(cImg,idx_modified(i));
            cc = bwconncomp(sRegion);
            if(cc.NumObjects>0)
                % not wholly erased
                tmp=zeros(handles.xdim,handles.ydim);
                tmp(cc.PixelIdxList{1})=1;                
                child=handles.cList{idx_modified(i)}.child;
                parent=handles.cList{idx_modified(i)}.parent;
                id=handles.cList{idx_modified(i)}.id;

                handles.cList{idx_modified(i)} = struct('seg',tmp,'size',numel(cc.PixelIdxList{1}),'child',child,'parent',parent,'id',id);
                
                if(cc.NumObjects>1)
                    % region is broken
                    max_id = handles.m;
                    for j=2:1:cc.NumObjects
                        max_id = max_id+1;
                        % update mat
                        cImg(cc.PixelIdxList{j})=max_id;
                        % update id
                        newidx = handles.Max + 1;
                        handles.Max = newidx;
                        idImg(cc.PixelIdxList{j})=newidx;
                        % update cell
                        tmp=zeros(handles.xdim,handles.ydim);
                        tmp(cc.PixelIdxList{j})=1;
                        handles.cList{max_id}=struct('seg',tmp,'size',numel(cc.PixelIdxList{j}),'child',[],'parent',[],'id',newidx);
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
        handles.idImg=idImg;
        handles.m = max_id;
        guidata(hObject, handles);
        
        if(non_brokenFlag)
            msgbox('Just a reminder: You choose to cut cells, but at least one cell is only pruned instead of cutted');
        end
    end
    %handles = rmfield(handles,'NImg');
    guidata(hObject, handles);
end


%%%% Select two cells %%%%%
% --- Executes on button press in Select.
function Select_Callback(hObject, eventdata, handles)
% hObject    handle to Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
str = ['handles.matEachFrame{1,',num2str(handles.counter1),'}'];
content = eval(str);
content = content';

% select a reference cell and get its location
axes(handles.axes1);
Loc = [-1 -1];
while (Loc(1)<0 || Loc(1)>512) || (Loc(2)<0 || Loc(2)>256)
    Loc = int16(ginput(1));disp(Loc);
end
idx = content(Loc(1),Loc(2));%disp(idx);

if idx<1e-5
    msgbox('Please click on a cell','Error','error');
else
    % update the display of parameters
    handles.preidx = idx;
    temp = handles.preidx;
    Preid = num2str(handles.cellEachFrame{1,handles.counter1}{1,temp}.id);
    Prechild = handles.cellEachFrame{1,handles.counter1}{1,temp}.child;
    CSiz = size(Prechild);
    handles.CSiz = CSiz(1);
    
    Preparent = handles.cellEachFrame{1,handles.counter1}{1,temp}.parent;
    PSiz = size(Preparent);
    handles.PSiz = PSiz(1);
    
    set(handles.Preid,'String',Preid);
    set(handles.Prechild,'String',handles.CSiz);
    set(handles.Preparent,'String',handles.PSiz);
    handles.action = 1;
    guidata(hObject, handles);
end

% --- Executes on button press in Select_Edit.
function Select_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
str = ['handles.matEachFrame{1,',num2str(handles.counter2),'}'];
content = eval(str);
content = content';

% select a corresponding cell and get its location
axes(handles.axes2);
Loc = [-1 -1];
while (Loc(1)<0 || Loc(1)>512) || (Loc(2)<0 || Loc(2)>256)
    Loc = int16(ginput(1));disp(Loc);
end
idx = content(Loc(1),Loc(2));disp(idx);
if idx >= 0 && idx <= 0
    msgbox('Please click on a cell!','Error','error');
else
    % update the display of parameters
    handles.idx = idx;
    temp = handles.idx;
    Postid = num2str(handles.cellEachFrame{1,handles.counter2}{1,temp}.id);
    Postchild = handles.cellEachFrame{1,handles.counter2}{1,temp}.child;
    CSiz = size(Postchild);
    if isempty(Postchild)
        Cstr = '';
    else
        handles.CSiz2 = CSiz(1);
        Cstr = '';
        for i = 1:handles.CSiz2
            Cstr = [Cstr,' Frame ',num2str(Postchild(i,1)),' Cell ',num2str(Postchild(i,2))];
        end
    end
    Postparent = handles.cellEachFrame{1,handles.counter2}{1,temp}.parent;
    PSiz = size(Postparent);
    if isempty(Postparent)
        Pstr = '';
    else
        handles.PSiz2 = PSiz(1);
        Pstr = '';
        for j = 1:handles.PSiz2
            Pstr = [Pstr,' Frame ',num2str(Postparent(j,1)),' Cell ',num2str(Postparent(j,2))];
        end
    end
    SN2str = num2str(temp);
    set(handles.Postid,'String',Postid);
    set(handles.Postchild,'String',Cstr);
    set(handles.Postparent,'String',Pstr);
    set(handles.SN2,'String',SN2str);
    handles.action2 = 1;
    guidata(hObject, handles);
end



%% Add Relation
% --- Executes on button press in Add_Relation.
function Add_Relation_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Relation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if handles.action == 0
    msgbox('Please select the reference cell!')
else if handles.action2 == 0
        msgbox('Please select the corresponding cell!')
    else
% suppose this is wrong, we want to swap the correspondence
tmp = ismember(handles.matEachFrame{1, handles.counter2},handles.idx); % old id (wrong)


choice = questdlg('Would you like to overwrite the previous or add new relation?', ...
	'Add Relation', ...
	'Overwrite the previous','Add new','Cancel','Overwrite the previous');
% Handle response
switch choice
    case 'Overwrite the previous'
        Postparent = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent;
        Prechild = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child;
        PCSiz = size(Prechild);
        handles.PCSiz = PCSiz(1);
        Wrongchild = [];
        if isempty(Prechild)
            disp('No child!');
        else 
            for k = 1:handles.PCSiz
                handles.cellEachFrame{1,Prechild(k,1)}{1,Prechild(k,2)}.id = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id;
                handles.cellEachFrame{1,Prechild(k,1)}{1,Prechild(k,2)}.parent = Postparent;
                changearea = ismember(handles.matEachFrame{1, handles.counter2},Prechild(k,2));
                mat_changearea = handles.idEachFrame{1, handles.counter2};
                mat_changearea(changearea>0) = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id;
                handles.idEachFrame{1, handles.counter2} = mat_changearea;
                Wrongchild = [Wrongchild; handles.cellEachFrame{1,Prechild(k,1)}{1,Prechild(k,2)}.child];
            end
        end
        
        PPSiz = size(Postparent);
        handles.PPSiz = PPSiz(1);
        if isempty(Postparent)
            disp('No parent');
        else
            for l = 1:handles.PPSiz
                C = handles.cellEachFrame{1, Postparent(l,1)}{1, Postparent(l,2)}.child;
                Cindex = C(:,2) >= handles.idx & C(:,2) <= handles.idx;
                handles.cellEachFrame{1, Postparent(l,1)}{1, Postparent(l,2)}.child(Cindex,:) = [];
                handles.cellEachFrame{1, Postparent(l,1)}{1, Postparent(l,2)}.child = [handles.cellEachFrame{1, Postparent(l,1)}{1, Postparent(l,2)}.child; Prechild];
            end
        end
          
        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child = [handles.counter2,handles.idx];
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent = [handles.counter1,handles.preidx];  
        
        % update all the following cells
        Postchild = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.child;
        while ~isempty(Postchild)
            row = size(Postchild);
            Ch = Postchild;
            Postchild = [];
            ROW = row(1);
            for numofarea = 1:ROW
                area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                mat_area(area>0) = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.id; % new id
                handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id; %updated id
                Postchild = [Postchild; handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.child];
            end
        end   
        
        % update the following wrongcell's id
        while ~isempty(Wrongchild)
            row = size(Wrongchild);
            Ch = Wrongchild;
            Wrongchild = [];
            ROW = row(1);
            for numofarea = 1:ROW
                area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                mat_area(area>0) = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.id; % new id
                handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id; %updated id
                Wrongchild = [Wrongchild; handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.child];
            end
        end 
        
        % modify the idx
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id;
    
    % Add new relation    
    case 'Add new'
        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child = [handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child;[handles.counter2,handles.idx]];
        Postparent = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent;
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent = [handles.counter1,handles.preidx];
        
        PPSiz = size(Postparent);
        handles.PPSiz = PPSiz(1);
        if isempty(Postparent)
            disp('No parent');
        else
            for l = 1:handles.PPSiz
                C = handles.cellEachFrame{1,Postparent(l,1)}{1,Postparent(l,2)}.child;
                Cindex = C(:,2) >= handles.idx & C(:,2) <= handles.idx;
                C(Cindex,:) = [];
                handles.cellEachFrame{1,Postparent(l,1)}{1,Postparent(l,2)}.child = C;
            end
        end
        
        % update all the following cells
        Postchild = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.child;
        while ~isempty(Postchild)
            row = size(Postchild);
            Ch = Postchild;
            Postchild = [];
            ROW = row(1);
            for numofarea = 1:ROW
                area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                mat_area(area>0) = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.id; % new id
                handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id; %updated id
                Postchild = [Postchild; handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.child];
            end
        end   
        %modify the idx
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id;
         
    case 'Cancel'
        disp('Add no relation');
end

mat_tmp = handles.idEachFrame{1, handles.counter2};
mat_tmp(tmp>0) = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.id; % new id
handles.idEachFrame{1, handles.counter2} = mat_tmp; % updated matrix

%update the display
axes(handles.axes2);
imshow(handles.idEachFrame{1, handles.counter2} + 1, handles.colormap);
%update the parameters
Prechild = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child;
CSiz = size(Prechild);
if isempty(Prechild)
    Cstr = '';
else
    handles.CSiz = CSiz(1);
    Cstr = '';
    for i = 1:handles.CSiz
        Cstr = [Cstr,' Frame ',num2str(Prechild(i,1)),' Cell ',num2str(Prechild(i,2))];
    end
end
set(handles.Prechild,'String',Cstr);

Postid = num2str(handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.id);
set(handles.Postid,'String',Postid);

Postparent = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.parent;
PSiz = size(Postparent);
if isempty(Postparent)
    Pstr2 = '';
else
    handles.PSiz2 = PSiz(1);
    Pstr2 = '';
    for j = 1:handles.PSiz2
        Pstr2 = [Pstr2,' Frame ',num2str(Postparent(j,1)),' Cell ',num2str(Postparent(j,2))];
    end
end
set(handles.Postparent,'String',Pstr2);

if handles.autosave == 1
    cellEachFrame = handles.cellEachFrame;
    idEachFrame = handles.idEachFrame;
    matEachFrame = handles.matEachFrame;
    rawEachFrame = handles.rawEachFrame;
    save(handles.FileName,'cellEachFrame','idEachFrame','matEachFrame','rawEachFrame');
end
guidata(hObject, handles);
    end
end



%% Delete Relation
% --- Executes on button press in Del_Relation.
function Del_Relation_Callback(hObject, eventdata, handles)
% hObject    handle to Del_Relation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if handles.action == 0
    msgbox('Please select the reference cell!')
else if handles.action2 == 0
        msgbox('Please select the corresponding cell!')
    else
% suppose this is wrong, we want to swap the correspondence
tmp2 = ismember(handles.matEachFrame{1, handles.counter2},handles.idx); % old id (wrong)

choice = questdlg('Would you like to delete the previous relation and give a new id to the intended cell?', ...
	'Delete', ...
	'Delete and give a new id','Cancel','Delete and give a new id');
% Handle response
switch choice
    case 'Delete and give a new id'
        Prechild = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child;
        Cindex = Prechild(:,2) >= handles.idx & Prechild(:,2) <= handles.idx;
        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child(Cindex,:) = [];
        
        Postchild = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.child;
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent = [];
        
        Postparent = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent;
        PPSiz = size(Postparent);
        handles.PPSiz = PPSiz(1);
        if isempty(Postparent)
            disp('No parent');
        else
            for l = 1:handles.PPSiz
                C = handles.cellEachFrame{1, Postparent(l,1)}{1, Postparent(l,2)}.child;
                Cindex = C(:,2) >= handles.idx & C(:,2) <= handles.idx;
                handles.cellEachFrame{1, Postparent(l,1)}{1, Postparent(l,2)}.child(Cindex,:) = [];
            end
        end
        
        newidx = handles.Max + 1;
        handles.Max = newidx;
        
        % update all the following cells
        while ~isempty(Postchild)
            row = size(Postchild);
            Ch = Postchild;
            Postchild = [];
            ROW = row(1);
            for numofarea = 1:ROW
                area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                mat_area(area>0) = newidx; % new id
                handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = newidx; %updated id
                Postchild = [Postchild; handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.child];
            end
        end   
        
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id = newidx;
        
        mat_tmp1 = handles.idEachFrame{1, handles.counter2};
        mat_tmp1(tmp2>0) = newidx; % new id
        handles.idEachFrame{1, handles.counter2} = mat_tmp1; % updated matrix
    
        PCSiz = size(Postchild);
        handles.PCSiz = PCSiz(1);
        for k = 1:handles.PCSiz
            PCP = handles.cellEachFrame{1,Postchild(k,1)}{1,Postchild(k,2)}.parent;
            PCPindex = PCP(:,2) >= handles.idx & PCP(:,2) <= handles.idx;
            handles.cellEachFrame{1, Postchild(k,1)}{1, Postchild(k,2)}.parent(PCPindex,:) = [];            
        end
        
    case 'Cancel'
        disp('Delete no relation');
end

%update the display
axes(handles.axes2);
imshow(handles.idEachFrame{1, handles.counter2} + 1, handles.colormap);
%update the parameters
Prechild = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child;
CSiz = size(Prechild);
if isempty(Prechild)
    Cstr = '';
else
    handles.CSiz = CSiz(1);
    Cstr = '';
    for i = 1:handles.CSiz
        Cstr = [Cstr,' Frame ',num2str(Prechild(i,1)),' Cell ',num2str(Prechild(i,2))];
    end
end
set(handles.Prechild,'String',Cstr);

Postid = num2str(handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.id);
set(handles.Postid,'String',Postid);

Postchild = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.child;
Siz = size(Postchild);
if isempty(Postchild)
    Cstr2 = '';
else
    Siz = Siz(1);
    Cstr2 = '';
    for i = 1:Siz
        Cstr2 = [Cstr2,' Frame ',num2str(Postchild(i,1)),' Cell ',num2str(Postchild(i,2))];
    end
end
set(handles.Postchild,'String',Cstr2);

Postparent = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.parent;
PSiz = size(Postparent);
if isempty(Postparent)
    Pstr2 = '';
else
    handles.PSiz2 = PSiz(1);
    Pstr2 = '';
    for j = 1:handles.PSiz2
        Pstr2 = [Pstr2,' Frame ',num2str(Postparent(j,1)),' Cell ',num2str(Postparent(j,2))];
    end
end
set(handles.Postparent,'String',Pstr2);

if handles.autosave == 1
    cellEachFrame = handles.cellEachFrame;
    idEachFrame = handles.idEachFrame;
    matEachFrame = handles.matEachFrame;
    rawEachFrame = handles.rawEachFrame;
    save(handles.FileName,'cellEachFrame','idEachFrame','matEachFrame','rawEachFrame');
end
guidata(hObject, handles);
    end
end



%% Modify Cell Fusion
% --- Executes on button press in Fusion.
function Fusion_Callback(hObject, eventdata, handles)
% hObject    handle to Fusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if handles.action == 0
    msgbox('Please select the reference cell!')
else if handles.action2 == 0
        msgbox('Please select the corresponding cell!')
    else
% modify fusion
tmp = ismember(handles.matEachFrame{1, handles.counter1},handles.preidx); % old id (wrong)

choice = questdlg('Would you like to modify the situation of cell fusion?', ...
	'Cell Fusion', ...
	'Add Fusion Relation','Cancel','Add Fusion Relation');
% Handle response
switch choice
    case 'Add Fusion Relation'
        Postparent = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent;
        Postparent = [Postparent;[handles.counter1, handles.preidx]];
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent = Postparent;
        
        Prechild = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child;
        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child = [];
        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child = [handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child;[handles.counter2, handles.idx]];
        PreCSiz = size(Prechild);
        handles.PreCSiz = PreCSiz(1);
        for k = 1:handles.PreCSiz
            PreCP = handles.cellEachFrame{1, Prechild(k,1)}{1, Prechild(k,2)}.parent;
            PreCPindex = PreCP(:,2) >= handles.preidx & PreCP(:,2) <= handles.preidx;
            handles.cellEachFrame{1, Prechild(k,1)}{1, Prechild(k,2)}.parent(PreCPindex,:) = [];
        end
                
        % update all the former id
        Preparent = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.parent;
        while ~isempty(Preparent)
            row = size(Preparent);
            Ch = Preparent;
            Preparent = [];
            ROW = row(1);
            for numofarea = 1:ROW
                area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                mat_area(area>0) = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.id; % new id
                handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id; %updated id
                Preparent = [Preparent; handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.parent];
            end
        end 
        
        % modify the id
        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id;
        mat_tmp = handles.idEachFrame{1, handles.counter1};
        mat_tmp(tmp>0) = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id; % new id
        handles.idEachFrame{1, handles.counter1} = mat_tmp; % updated matrix
        
    case 'Cancel'
        disp('Add no relation of cell fusion');
end

%update the display
axes(handles.axes1);
imshow(handles.idEachFrame{1, handles.counter1} + 1, handles.colormap);
%update the parameters
Preid = num2str(handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.id);
set(handles.Preid,'String',Preid);

Prechild = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child;
CSiz = size(Prechild);
if isempty(Prechild)
    Cstr = '';
else
    handles.CSiz = CSiz(1);
    Cstr = '';
    for i = 1:handles.CSiz
        Cstr = [Cstr,' Frame ',num2str(Prechild(i,1)),' Cell ',num2str(Prechild(i,2))];
    end
end
set(handles.Prechild,'String',Cstr);

Postparent = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.parent;
PSiz = size(Postparent);
if isempty(Postparent)
    Pstr2 = '';
else
    handles.PSiz2 = PSiz(1);
    Pstr2 = '';
    for j = 1:handles.PSiz2
        Pstr2 = [Pstr2,' Frame ',num2str(Postparent(j,1)),' Cell ',num2str(Postparent(j,2))];
    end
end
set(handles.Postparent,'String',Pstr2);

if handles.autosave == 1
    cellEachFrame = handles.cellEachFrame;
    idEachFrame = handles.idEachFrame;
    matEachFrame = handles.matEachFrame;
    rawEachFrame = handles.rawEachFrame;
    save(handles.FileName,'cellEachFrame','idEachFrame','matEachFrame','rawEachFrame');
end
guidata(hObject, handles);
    end 
end



%% Set the Segmentation flag 
% --- Executes on button press in Seg_Add.
function Seg_Add_Callback(hObject, eventdata, handles)
% hObject    handle to Seg_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
axes(handles.axes2);
set(gca,'NextPlot','add');
freezeColors;
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=1;
    Fflag=0;
    Dflag=0;
    Sflag=0;
    set(handles.Seg_Fix,'Value',0);
    set(handles.Seg_Separate,'Value',0);
    set(handles.Seg_Delete,'Value',0);
elseif button_state==get(hObject,'Min')
    Aflag=0;
    set(handles.Seg_Add,'Value',0);
end
guidata(hObject, handles);


% --- Executes on button press in Seg_Delete.
function Seg_Delete_Callback(hObject, eventdata, handles)
% hObject    handle to Seg_Delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
axes(handles.axes2);
set(gca,'NextPlot','add');
freezeColors;
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=0;
    Fflag=0;
    Dflag=1;
    Sflag=0;
    set(handles.Seg_Fix,'Value',0);
    set(handles.Seg_Separate,'Value',0);
    set(handles.Seg_Add,'Value',0);
elseif button_state==get(hObject,'Min')
    Dflag=0;
    set(handles.Seg_Delete,'Value',0);
end
guidata(hObject, handles);


% --- Executes on button press in Seg_Separate.
function Seg_Separate_Callback(hObject, eventdata, handles)
% hObject    handle to Seg_Separate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
axes(handles.axes2);
set(gca,'NextPlot','add');
freezeColors;
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=0;
    Fflag=0;
    Dflag=0;
    Sflag=1;
    set(handles.Seg_Fix,'Value',0);
    set(handles.Seg_Add,'Value',0);
    set(handles.Seg_Delete,'Value',0);
elseif button_state==get(hObject,'Min')
    Sflag=0;
    set(handles.Seg_Separate,'Value',0);
end
guidata(hObject, handles);


% --- Executes on button press in Seg_Fix.
function Seg_Fix_Callback(hObject, eventdata, handles)
% hObject    handle to Seg_Fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Aflag Fflag Dflag Sflag
axes(handles.axes2);
set(gca,'NextPlot','add');
freezeColors;
button_state=get(hObject,'Value');
if button_state == get(hObject,'Max')
    Aflag=0;
    Fflag=1;
    Dflag=0;
    Sflag=0;
    set(handles.Seg_Separate,'Value',0);
    set(handles.Seg_Delete,'Value',0);
    set(handles.Seg_Add,'Value',0);
elseif button_state==get(hObject,'Min')
    Fflag=0;
    set(handles.Seg_Fix,'Value',0);
end
guidata(hObject, handles);



%% Save the present segmentation Modification work
% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Saveflag;
Saveflag = 1;
handles = guidata(hObject);

Img=handles.Img;
idImg=handles.idImg;
cList=handles.cList;

rm_idx=[];
for i=1:1:numel(cList)
    if(isempty(cList{i}))
        rm_idx=cat(1,rm_idx,i);
    end
end

if(isempty(rm_idx))
    handles.matEachFrame{1,handles.counter2}=Img;
    handles.idEachFrame{1,handles.counter2}=idImg;
    handles.cellEachFrame{1,handles.counter2}=cList;
else
    idx=setdiff(1:1:numel(cList),rm_idx);
    nList=cell(1,numel(idx));
    nList(:)=cList(idx);
    handles.cellEachFrame{1,handles.counter2} = nList;
    Img = zeros(handles.xdim,handles.ydim);
    for i=1:1:numel(idx)
        Img(nList{i}.seg)=i;
        idImg(nList{i}.seg)=nList{i}.id;
    end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % modify the child-parent relationship according to the change of cList
    for j = 1:numel(rm_idx)
            Modnum = rm_idx(j);
            for k = Modnum:1:numel(idx)
                % modify parent
                Lastparent = cList{k + 1}.parent;
                LpSiz = size(Lastparent);
                if isempty(Lastparent)
                    disp('No parent');
                else
                    for m = 1:LpSiz(1)
                        C = handles.cellEachFrame{1, Lastparent(m,1)}{1, Lastparent(m,2)}.child;
                        Cindex = C(:,2) >= k+1 & C(:,2) <= k+1 & C(:,1) >= handles.counter2 & C(:,1) <= handles.counter2;
                        C(Cindex,:) = [];
                        C = [C;[handles.counter2, k]];                     
                        handles.cellEachFrame{1, Lastparent(m,1)}{1, Lastparent(m,2)}.child = C;
                    end
                end
                %%%%%%%%%%%%%%%
                % modify child
                Firstchild = cList{k + 1}.child;
                FcSiz = size(Firstchild);
                if isempty(Firstchild)
                    disp('No child');
                else
                    for m = 1:FcSiz(1)
                        P = handles.cellEachFrame{1, Firstchild(m,1)}{1, Firstchild(m,2)}.parent;
                        Pindex = P(:,2) >= k+1 & P(:,2) <= k+1 & P(:,1) >= handles.counter2 & P(:,1) <= handles.counter2;
                        P(Pindex,:) = [];
                        P = [P;[handles.counter2, k]];                     
                        handles.cellEachFrame{1, Firstchild(m,1)}{1, Firstchild(m,2)}.parent = P;
                    end
                end
                %%%%%%%%%%%%%%%
            end
    end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    handles.matEachFrame{1,handles.counter2} = Img;
    handles.idEachFrame{1,handles.counter2} = idImg;
    
    handles.Img = Img;
    handles.idImg = idImg;
    handles.cList = handles.cellEachFrame{1,handles.counter2};
end

guidata(hObject, handles);

axes(handles.axes2);
set(gca,'NextPlot','replace');
imshow(handles.idEachFrame{1,handles.counter2} + 1,handles.colormap);
%freezeColors;

set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});

msgbox('save successfully','Infor');



%% parameter for the BrushSize
% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = round(get(hObject,'Value')) + 1;
set(handles.BrushSize,'String',[num2str(val)]);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%% Flag for AutoSave
% --- Executes on button press in AutoSave.
function AutoSave_Callback(hObject, eventdata, handles)
% hObject    handle to AutoSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AutoSave
handles = guidata(hObject);
val = get(hObject,'Value');
if val == 1
    handles.autosave = 1;
else
    handles.autosave = 0;
end
guidata(hObject, handles);



%% Save all 
% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Are you sure to save the present work?', ...
	'Save', ...
	'Yes,absolutely!','No','No');
% Handle response
switch choice
    case 'Yes,absolutely!'
        handles = guidata(hObject);
        cellEachFrame = handles.cellEachFrame;
        idEachFrame = handles.idEachFrame;
        matEachFrame = handles.matEachFrame;
        rawEachFrame = handles.rawEachFrame;
        save(handles.FileName,'cellEachFrame','idEachFrame','matEachFrame','rawEachFrame');
        msgbox('save successfully ^_^','Infor');
        guidata(hObject, handles);
    case 'No'
        disp('Do not save!');
end


%% Exit safely
% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Would you really like to quit the GUI tool?', ...
	'Warning', ...
	'Yes,absolutely!','No','No');
% Handle response
switch choice
    case 'Yes,absolutely!'
        close(gcf);
    case 'No'
        disp('Do not exit!');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% No need to change the following code%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in Postid.
function Postid_Callback(hObject, eventdata, handles)
% hObject    handle to Postid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Postid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Postid


% --- Executes during object creation, after setting all properties.
function Postid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Postid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Preid_Callback(hObject, eventdata, handles)
% hObject    handle to Preid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Preid as text
%        str2double(get(hObject,'String')) returns contents of Preid as a double


% --- Executes during object creation, after setting all properties.
function Preid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Preid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Prechild_Callback(hObject, eventdata, handles)
% hObject    handle to Prechild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Prechild as text
%        str2double(get(hObject,'String')) returns contents of Prechild as a double


% --- Executes during object creation, after setting all properties.
function Prechild_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Prechild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Preparent_Callback(hObject, eventdata, handles)
% hObject    handle to Preparent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Preparent as text
%        str2double(get(hObject,'String')) returns contents of Preparent as a double


% --- Executes during object creation, after setting all properties.
function Preparent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Preparent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Postparent_Callback(hObject, eventdata, handles)
% hObject    handle to Postparent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Postparent as text
%        str2double(get(hObject,'String')) returns contents of Postparent as a double


% --- Executes during object creation, after setting all properties.
function Postparent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Postparent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Postchild_Callback(hObject, eventdata, handles)
% hObject    handle to Postchild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Postchild as text
%        str2double(get(hObject,'String')) returns contents of Postchild as a double


% --- Executes during object creation, after setting all properties.
function Postchild_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Postchild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SN_Callback(hObject, eventdata, handles)
% hObject    handle to SN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SN as text
%        str2double(get(hObject,'String')) returns contents of SN as a double



% --- Executes during object creation, after setting all properties.
function SN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SN2_Callback(hObject, eventdata, handles)
% hObject    handle to SN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SN2 as text
%        str2double(get(hObject,'String')) returns contents of SN2 as a double



% --- Executes during object creation, after setting all properties.
function SN2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BrushSize_Callback(hObject, eventdata, handles)
% hObject    handle to BrushSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BrushSize as text
%        str2double(get(hObject,'String')) returns contents of BrushSize as a double


% --- Executes during object creation, after setting all properties.
function BrushSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BrushSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in consecutive.
function consecutive_Callback(hObject, eventdata, handles)
% hObject    handle to consecutive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of consecutive
