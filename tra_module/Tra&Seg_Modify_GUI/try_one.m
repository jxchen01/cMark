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

% Last Modified by GUIDE v2.5 20-Sep-2015 21:22:18

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
global Mflag
Mflag=0;

handles.output = hObject;

% set the slider's parameters
set(handles.slider, 'Max', 7,'Min',0);
set(handles.slider, 'SliderStep', [1/8 1]);
handles.Brush=1;

% size of window
set(handles.uipanel2,'unit','normalized','position',[0.01,0.01,0.99,0.99]);

handles.autosave = 0;
handles.consecutive=0;
handles.certaincell = 0;
handles.certainidx = 1;
   
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
global Mflag Aflag Fflag Sflag Dflag Saveflag Segflag;
Mflag = 0;
Aflag = 0;
Fflag = 0;
Sflag = 0;
Dflag = 0;
Segflag=0;
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
   
   [dimx,dimy]=size(matEachFrame{1,2});
   handles.xdim = dimx;
   handles.ydim = dimy;
   
   handles.Maxindex = numel(rawEachFrame); % max frame index
   handles.Max = 0; % max id
   handles.reusable = [];
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

   set(handles.GotoFrame,'String',num2str(handles.counter1));
   set(handles.GotoFrame2,'String',num2str(handles.counter2));
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    %%%%%% set up the window for potential segmentation correction %%%%%%
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    % let the user be able to draw on the image
%    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
%    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
%    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
%    
   guidata(hObject, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%   visualization  %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in Gonext.
function Gonext_Callback(hObject, eventdata, handles)
% hObject    handle to Gonext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segflag
if(Segflag)
    return
end

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
    set(handles.GotoFrame,'String',num2str(handles.counter1));
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
        if(handles.consecutive==1)
            if(handles.counter1==handles.Maxindex)
                handles.counter2=handles.Maxindex;
            else
                handles.counter2 = handles.counter1 + 1;
            end
            
            set(handles.Postid,'String',[]);
            set(handles.Postchild,'String',[]);
            set(handles.Postparent,'String',[]);
            set(handles.GotoFrame2,'String',num2str(handles.counter2));
            
            guidata(hObject, handles);
    
            %%%%% update visualization %%%%
            axes(handles.axes2);
            imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1, handles.colormap));
            
        end
    end

    guidata(hObject, handles);
end

% --- Executes on button press in Goback.
function Goback_Callback(hObject, eventdata, handles)
% hObject    handle to Goback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segflag
if(Segflag)
    return
end

handles = guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end

if handles.counter1 == 1
    msgbox('Already in the first frame','Error','error') 
else
    handles.counter1 = handles.counter1 - 1;
    set(handles.Preid,'String',[]);
    set(handles.Prechild,'String',[]);
    set(handles.Preparent,'String',[]);
    set(handles.GotoFrame,'String',num2str(handles.counter1));
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
        if(handles.consecutive==1)
            if(handles.counter1==1)
                handles.counter2=2;
            else
                handles.counter2 = handles.counter1 + 1;
            end
            
            set(handles.Postid,'String',[]);
            set(handles.Postchild,'String',[]);
            set(handles.Postparent,'String',[]);
            set(handles.GotoFrame2,'String',num2str(handles.counter2));
            
            guidata(hObject, handles);
            
            %%%%% update visualization %%%%
            axes(handles.axes2);
            imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1, handles.colormap));
        end
    end
    
    guidata(hObject, handles);
end


function GotoFrame_Callback(hObject, eventdata, handles)
% hObject    handle to GotoFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoFrame as text
%        str2double(get(hObject,'String')) returns contents of GotoFrame as a double
global Segflag
if(Segflag)
    return
end

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
        imshow(ind2rgb(handles.idEachFrame{1,handles.counter1} + 1,handles.colormap));
        if(handles.consecutive==1)
            if(handles.counter1==1)
                handles.counter2=2;
            elseif(handles.counter1==handles.Maxindex)
                handles.counter2=handles.Maxindex;
            else
                handles.counter2 = handles.counter1 + 1;
            end
            
            set(handles.Postid,'String',[]);
            set(handles.Postchild,'String',[]);
            set(handles.Postparent,'String',[]);
            set(handles.GotoFrame2,'String',num2str(handles.counter2));
            
            guidata(hObject, handles);
            
            %%%%% update visualization %%%%
            axes(handles.axes2);
            imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1, handles.colormap));
        end
    end
    guidata(hObject, handles);
end


% --- Executes on button press in Gonext2.
function Gonext2_Callback(hObject, eventdata, handles)
% hObject    handle to Gonext2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segflag

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
    guidata(hObject, handles);
    
    %%%% update visualization %%%%
    axes(handles.axes2);
    imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1, handles.colormap));
    
    if(Segflag==1)
        %%%% prepare for segmentation correction
        set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
        set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
        set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
        set(gca,'NextPlot','replace');
        
        handles.Img=handles.matEachFrame{1,handles.counter2};
        handles.idImg = handles.idEachFrame{1,handles.counter2};
        handles.cList=handles.cellEachFrame{1,handles.counter2};
        
        guidata(hObject, handles);
    end
    
end


% --- Executes on button press in Goback2.
function Goback2_Callback(hObject, eventdata, handles)
% hObject    handle to Goback2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segflag;
handles = guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end

if handles.counter2 == 1
    msgbox('Already in the first frame','Error','error') 
else
    handles.action2 = 0;
    handles.counter2 = handles.counter2 - 1;
    set(handles.Postid,'String',[]);
    set(handles.Postchild,'String',[]);
    set(handles.Postparent,'String',[]);
    set(handles.GotoFrame2,'String',num2str(handles.counter2));
    guidata(hObject, handles);
    
    %%%%% update visualization %%%%
    axes(handles.axes2);
    imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1, handles.colormap));

    if(Segflag)
        %%%%% prepare for segmentation correction %%%%%
        set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
        set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
        set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
        
        handles.Img=handles.matEachFrame{1,handles.counter2};
        handles.idImg = handles.idEachFrame{1, handles.counter2};
        handles.cList=handles.cellEachFrame{1,handles.counter2};
        
        guidata(hObject, handles);
    end
end


function GotoFrame2_Callback(hObject, eventdata, handles)
% hObject    handle to GotoFrame2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoFrame2 as text
%        str2double(get(hObject,'String')) returns contents of GotoFrame2 as a double
global Segflag;
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
    guidata(hObject, handles);
    
    %%%% update visualization %%%%
    axes(handles.axes2);
    imshow(ind2rgb(handles.idEachFrame{1,handles.counter2} + 1,handles.colormap));
 
    if(Segflag)
        %%%% prepare for segmentation correction %%%%
        set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
        set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
        set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
        
        handles.Img=handles.matEachFrame{1,handles.counter2};
        handles.idImg = handles.idEachFrame{1, handles.counter2};
        handles.cList=handles.cellEachFrame{1,handles.counter2};
        guidata(hObject, handles);
    end
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Select two cells %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Select.
function Select_Callback(hObject, eventdata, handles)
% hObject    handle to Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if(~isfield(handles,'FileName'))
    return
end

str = ['handles.matEachFrame{1,',num2str(handles.counter1),'}'];
content = eval(str);
content = content';
clear str

% select a reference cell and get its location
axes(handles.axes1);
Loc = [-1 -1];
while (Loc(1)<0 || Loc(1)>handles.ydim || Loc(2)<0 || Loc(2)>handles.xdim)
    Loc = int16(ginput(1));%disp(Loc);
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

if(~isfield(handles,'FileName'))
    return
end

str = ['handles.matEachFrame{1,',num2str(handles.counter2),'}'];
content = eval(str);
content = content';
clear str

% select a corresponding cell and get its location
axes(handles.axes2);
Loc = [-1 -1];
while (Loc(1)<1 || Loc(1)>handles.ydim || Loc(2)<1 || Loc(2)>handles.xdim)
    Loc = int16(ginput(1));%disp(Loc);
end
idx = content(Loc(1),Loc(2));%disp(idx);
if idx <1e-5
    msgbox('Please click on a cell!','Error','error');
else
    % update the display of parameters
    handles.idx = idx;
    temp = handles.idx;
    Postid = num2str(handles.cellEachFrame{1,handles.counter2}{1,temp}.id);
    Postchild = handles.cellEachFrame{1,handles.counter2}{1,temp}.child;
    
    CSiz = size(Postchild);
    handles.CSiz2 = CSiz(1);

    Postparent = handles.cellEachFrame{1,handles.counter2}{1,temp}.parent;
    PSiz = size(Postparent);
    handles.PSiz2 = PSiz(1);
   
    set(handles.Postid,'String',Postid);
    set(handles.Postchild,'String',handles.CSiz2);
    set(handles.Postparent,'String',handles.PSiz2);
    handles.action2 = 1;
    guidata(hObject, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% relationship correction %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Add Relation
% --- Executes on button press in Add_Relation.
function Add_Relation_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Relation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if(~isfield(handles,'FileName'))
    return
end

if handles.action == 0
    msgbox('Please select a cell in window 1 as a parent cell')
    return
elseif handles.action2 == 0
    msgbox('Please select a cell in windwo 2 as a child cell')
    return
end

if(handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id ==...
        handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id)
    msgbox('The selected two cells already in the same trajectory.');
    return
end

Postparent = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent;
Prechild = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child;

ppnum = size(Postparent,1);
pcnum = size(Prechild,1);

if(ppnum>0 || pcnum>0)
    choice = questdlg('Other relationship exists. Want to combine?', ...
	'Possible fusion or division','Yes', 'No','No');
    switch choice
        case 'Yes'
            if(ppnum>0 && pcnum==0)
                if(handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id ==...
                        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id)
                    msgbox('there may be false division or false fusion in previous frames');
                    return
                end
                % select the id of child cell as newidx and recyle the old ond
                handles.reusable = cat(2,handles.reusable, handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.id);
                newidx = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id;
                
                % update the parent of child cell
                handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent=...
                    cat(1,handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent,...
                    [handles.counter1,handles.preidx]);
            
                % update the child of parent cell
                handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child=...
                    [handles.counter2,handles.idx];
                
                % update the label matrix
                tmp1 = ismember(handles.matEachFrame{1, handles.counter1},handles.preidx); % old id (wrong)
                mat_tmp1 = handles.idEachFrame{1, handles.counter1};
                mat_tmp1(tmp1>0) = newidx; % new id
                handles.idEachFrame{1, handles.counter1} = mat_tmp1; % updated matrix
                
                % update all the upstream cells
                Preparent_tmp=handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.parent;
                while ~isempty(Preparent_tmp)
                    Ch = Preparent_tmp;
                    Preparent_tmp = [];
                    for numofarea = 1:size(Ch,1)
                        area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                        mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                        mat_area(area>0) = newidx; % new id
                        handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                        handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = newidx; %updated id
                        Preparent_tmp = cat(1,Preparent_tmp,handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.parent);
                    end
                end
                clear Preparent_tmp Ch numofarea mat_area area
   
            elseif(ppnum==0 && pcnum>0)              
                if(handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id ==...
                        handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id)
                    msgbox('there may be false division or false fusion in previous frames');
                    return
                end
                % select the id of parent cell as newidx and recycle the old id
                handles.reusable = cat(2,handles.reusable,handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id);
                newidx = handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id ;
                
                % update the child of parent cell
                handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child=...
                    cat(1,handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child,...
                    [handles.counter2,handles.idx]);
                
                % update the parent of child cell
                handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent=[handles.counter1,handles.preidx]; 
                
                % update the label matrix
                tmp2 = ismember(handles.matEachFrame{1, handles.counter2},handles.idx); % old id (wrong)
                mat_tmp1 = handles.idEachFrame{1, handles.counter2};
                mat_tmp1(tmp2>0) = newidx; % new id
                handles.idEachFrame{1, handles.counter2} = mat_tmp1; % updated matrix
                
                % update all the following cells
                Postchild_tmp=handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.child;
                while ~isempty(Postchild_tmp)
                    Ch = Postchild_tmp;
                    Postchild_tmp = [];
                    for numofarea = 1:size(Ch,1)
                        area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                        mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                        mat_area(area>0) = newidx; % new id
                        handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                        handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = newidx; %updated id
                        Postchild_tmp = cat(1,Postchild_tmp,handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.child);
                    end
                end
                clear Postchild_tmp Ch numofarea mat_area area
            else
                msgbox('Combining with existing relationship will cause many-to-many matching, please check again.');
                return
            end
        case 'No'
            msgbox('To avoid combining, you must delete the old relationship first');
            return
    end
else
    %%%% link two cell directly %%%%
    handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child =...
        [handles.counter2,handles.idx];
    handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent = ...
        [handles.counter1,handles.preidx]; 
    
    %%%% recylce the id and pass parent id to the new child %%%%
    handles.reusable = cat(2,handles.reusable , handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id);
    newidx=handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id;
    handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id = newidx;
    
    % update the label matrix
    tmp2 = ismember(handles.matEachFrame{1, handles.counter2},handles.idx); % old id (wrong)
    mat_tmp1 = handles.idEachFrame{1, handles.counter2};
    mat_tmp1(tmp2>0) = newidx; % new id
    handles.idEachFrame{1, handles.counter2} = mat_tmp1; % updated matrix
    
    % update all the following cells
    Postchild_tmp=handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.child;
    while ~isempty(Postchild_tmp)
        Ch = Postchild_tmp;
        Postchild_tmp = [];
        for numofarea = 1:size(Ch,1)
            area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
            mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
            mat_area(area>0) = newidx; % new id
            handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
            handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = newidx; %updated id
            Postchild_tmp = cat(1,Postchild_tmp,handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.child);
        end
    end
    clear Postchild_tmp Ch numofarea mat_area area

end

set(handles.Preid,'String',handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id);
set(handles.Prechild,'String',numel(handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.child)/2);
set(handles.Postid,'String',handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id);
set(handles.Postparent,'String',numel(handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent)/2);

%update the image
axes(handles.axes1);
imshow(ind2rgb(handles.idEachFrame{1, handles.counter1} + 1, handles.colormap));

axes(handles.axes2);
imshow(ind2rgb(handles.idEachFrame{1, handles.counter2} + 1, handles.colormap));

if handles.autosave == 1
    cellEachFrame = handles.cellEachFrame;
    idEachFrame = handles.idEachFrame;
    matEachFrame = handles.matEachFrame;
    rawEachFrame = handles.rawEachFrame;
    save(handles.FileName,'cellEachFrame','idEachFrame','matEachFrame','rawEachFrame');
end
guidata(hObject, handles);


%%%%% Delete Relation %%%%%
% --- Executes on button press in Del_Relation.
function Del_Relation_Callback(hObject, eventdata, handles)
% hObject    handle to Del_Relation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end
if handles.action == 0
    msgbox('Please select a cell in window 1 as a parent cell.')
    return
elseif handles.action2 == 0
    msgbox('Please select a cell in window 2 as a child cell.')
    return
end

% suppose this is wrong, we want to swap the correspondence
choice = questdlg('Would you like to delete the previous relation and give a new id to the intended cell?', ...
	'Delete', ...
	'Delete','Cancel','Delete');
% Handle response
switch choice
    case 'Delete'
        
        if(handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.id ~=...
            handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id)
            msgbox('The selected two cells have no relationship to delete.');
            return
        end
    
        Postparent = handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent;
        Prechild = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child;
        
        Cindex = find(Prechild(:,2) == handles.idx);
        Pindex = find(Postparent(:,2) == handles.preidx); 
        if(isempty(Cindex) || isempty(Pindex))
            msgbox('The selected two cells have no relationship to delete.');
            return
        end
        
        ppnum = size(Postparent,1);
        pcnum = size(Prechild,1);
        
        if(~isempty(handles.reusable))
            newidx = handles.reusable(end);
            handles.reusable(end)=[];
        else
            newidx = handles.Max + 1;
            handles.Max = newidx;
        end
       
        if(ppnum==1)
            % update the child of parent cell
            handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child(Cindex,:)=[];
            
            % update the parent of child cell
            handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent=[];
            
            % update the id of the child cell
            handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.id = newidx;
            
            % update the label matrix
            tmp2 = ismember(handles.matEachFrame{1, handles.counter2},handles.idx); % old id (wrong)
            mat_tmp1 = handles.idEachFrame{1, handles.counter2};
            mat_tmp1(tmp2>0) = newidx; % new id
            handles.idEachFrame{1, handles.counter2} = mat_tmp1; % updated matrix
            
            % update all the following cells
            Postchild_tmp=handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.child;
            while ~isempty(Postchild_tmp)
                Ch = Postchild_tmp;
                Postchild_tmp = [];
                for numofarea = 1:size(Ch,1)
                    area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                    mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                    mat_area(area>0) = newidx; % new id
                    handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                    handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = newidx; %updated id
                    Postchild_tmp = cat(1,Postchild_tmp,handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.child);
                end
            end
            clear Postchild_tmp Ch numofarea mat_area area
            
            %update the display
            axes(handles.axes2);
            imshow(ind2rgb(handles.idEachFrame{1, handles.counter2} + 1, handles.colormap));
            
        
            %update the parameters
            Prechild = handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child; %%% maybe nonzero
            set(handles.Prechild,'String',numel(Prechild)/2);

            set(handles.Postid,'String',newidx);
            set(handles.Postparent,'String',0);

        elseif(ppnum>1 && pcnum==1)
            % update the parent of child cell
            handles.cellEachFrame{1, handles.counter2}{1, handles.idx}.parent(Pindex,:)=[];
            
            % update the child of parent cell
            handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.child=[];
            
            % update the id of parent cell
            handles.cellEachFrame{1,handles.counter1}{1,handles.preidx}.id=newidx;
            
            % update the label matrix
            tmp1 = ismember(handles.matEachFrame{1, handles.counter1},handles.preidx); % old id (wrong)
            mat_tmp1 = handles.idEachFrame{1, handles.counter1};
            mat_tmp1(tmp1>0) = newidx; % new id
            handles.idEachFrame{1, handles.counter1} = mat_tmp1; % updated matrix
            
            % update all the upstream cells
            Preparent_tmp=handles.cellEachFrame{1, handles.counter1}{1, handles.preidx}.parent;
            while ~isempty(Preparent_tmp)
                Ch = Preparent_tmp;
                Preparent_tmp = [];
                for numofarea = 1:size(Ch,1)
                    area = ismember(handles.matEachFrame{1, Ch(numofarea,1)}, Ch(numofarea,2));
                    mat_area = handles.idEachFrame{1, Ch(numofarea,1)};
                    mat_area(area>0) = newidx; % new id
                    handles.idEachFrame{1, Ch(numofarea,1)} = mat_area; % updated matrix
                    handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.id = newidx; %updated id
                    Preparent_tmp = cat(1,Preparent_tmp,handles.cellEachFrame{1, Ch(numofarea,1)}{1, Ch(numofarea,2)}.parent);
                end
            end
            clear Preparent_tmp Ch numofarea mat_area area
            
            %update the display
            axes(handles.axes1);
            imshow(ind2rgb(handles.idEachFrame{1, handles.counter1} + 1, handles.colormap));
            
            %update the parameters
            Postparent = handles.cellEachFrame{1,handles.counter2}{1,handles.idx}.parent; %%% maybe nonzero
            set(handles.Postparent,'String',numel(Postparent)/2);

            set(handles.Preid,'String',newidx);
            set(handles.Prechild,'String',0);
        else
            % recycle the "newidx"
            handles.reusable = cat(2, handles.reusable, newidx);
            msgbox('many-to-many relationship, please check segmentation');
            return
        end        
    case 'Cancel'
        return
end

if handles.autosave == 1
    cellEachFrame = handles.cellEachFrame;
    idEachFrame = handles.idEachFrame;
    matEachFrame = handles.matEachFrame;
    rawEachFrame = handles.rawEachFrame;
    save(handles.FileName,'cellEachFrame','idEachFrame','matEachFrame','rawEachFrame');
end
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  Segmentation Correction  %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure2_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segflag Mflag x0 y0 x y Dflag Sflag value Fflag Aflag;

if(~Segflag)
    return
end

% retrieve the lastest handles 
handles = guidata(hObject);

cp = get(handles.axes2, 'CurrentPoint');
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
            plot(handles.axes2, x, y, 'Color', 'r');
            drawnow
        elseif Fflag         
            plot(handles.axes2, x, y, 'Color', 'w');
            drawnow   
        elseif Sflag
            plot(handles.axes2, x, y, 'Color', 'k');
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
            
            axes(handles.axes2);
            imshow(handles.raw);
            hold on
            h=imshow(ind2rgb(cImg,handles.colormap));
            hold off
            alpha=0.55.*ones(handles.xdim,handles.ydim);
            set(h,'AlphaData',alpha);

            set(gca,'NextPlot','add');
            set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
            set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
            set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
            
            clear h
            
%             axes(handles.Fig_raw);
%             imshow(handles.raw);
        end
    end    
else
    Mflag=0;
end

% --- Executes on mouse motion over figure - except title and menu.
function figure2_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segflag Mflag x0 y0 x y Aflag Fflag Sflag Saveflag; 
% 
% if isMultipleCall();  
%     return;  
% end

if (Segflag && Mflag)
    %%%% set the current point as (x0,y0), preparing for following
    %%%% button motion drawing
    x0 = x;
    y0 = y;
    
    handles = guidata(hObject);
    
    cp = get(handles.axes2, 'CurrentPoint');
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
%         NImg=zeros(handles.xdim,handles.ydim);
%         NImg(ind)=1;
%         se = strel('disk',LineWidth,0);
%         NImg=imdilate(NImg,se);
%         handles.NImg = handles.NImg | NImg;
        guidata(hObject, handles);
        
        if Aflag
            Saveflag = 0;
            plot(handles.axes2, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', 'r');
            drawnow;
        elseif Fflag
            Saveflag = 0;
            plot(handles.axes2, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', 'w');
            drawnow;         
        elseif Sflag
            Saveflag = 0;
            plot(handles.axes2, [x0 x], [y0 y], 'LineWidth', LineWidthPlot, 'Color', 'k');
            drawnow;
        end
    end
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure2_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mflag Aflag Fflag value Sflag Segflag;

if (Segflag && Mflag)
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
        NImg=handles.NImg;
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
    
    axes(handles.axes2);
    imshow(handles.raw);
    hold on
    h=imshow(ind2rgb(handles.Img,handles.colormap));
    hold off
    alpha=0.55.*ones(handles.xdim,handles.ydim);
    set(h,'AlphaData',alpha);
    set(gca,'NextPlot','add');
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});
    
    clear h
    
%    axes(handles.Fig_raw);
%    imshow(handles.raw);

    guidata(hObject, handles);
end


%%%%% Save the present segmentation Modification work %%%%%
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
            end
    end
  
    handles.matEachFrame{1,handles.counter2} = Img;
    handles.idEachFrame{1,handles.counter2} = idImg;
    
    handles.Img = Img;
    handles.idImg = idImg;
    handles.cList = handles.cellEachFrame{1,handles.counter2};
end

guidata(hObject, handles);

axes(handles.axes2);
set(gca,'NextPlot','add');
imshow(handles.idEachFrame{1,handles.counter2} + 1,handles.colormap);
%freezeColors;

set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles});

msgbox('save successfully','Infor');

% --- Executes on selection change in seg.
function seg_Callback(hObject, eventdata, handles)
% hObject    handle to seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seg
global Aflag Fflag Dflag Sflag Segflag

handles=guidata(hObject);
if(~isfield(handles,'FileName'))
    return
end

str = get(hObject, 'String');
val = get(hObject,'Value');
switch str{val};
    case 'None'
        Segflag=0;
        return
    case 'Add'
        Segflag=1;
        Aflag=1;
        Fflag=0;
        Dflag=0;
        Sflag=0;
    case 'Fix (+)'
        Segflag=1;
        Aflag=0;
        Fflag=1;
        Dflag=0;
        Sflag=0;
    case 'Fix (-)'
        Segflag=1;
        Aflag=0;
        Fflag=0;
        Dflag=0;
        Sflag=1;
    case 'Delete'
        Segflag=1;
        Aflag=0;
        Fflag=0;
        Dflag=1;
        Sflag=0;
end

if(Segflag==1)  
    handles.Img=handles.matEachFrame{1,handles.counter2};
    handles.idImg = handles.idEachFrame{1,handles.counter2};
    handles.cList=handles.cellEachFrame{1,handles.counter2};
    handles.raw=handles.rawEachFrame{1,handles.counter2};
    
    guidata(hObject, handles);
    
    axes(handles.axes2);
    imshow(handles.raw);
    hold on
    h=imshow(ind2rgb(handles.Img,handles.colormap));
    hold off
    alpha=0.55.*ones(handles.xdim,handles.ydim);
    set(h,'AlphaData',alpha);

    set(handles.axes2,'NextPlot','add');
    %%%% prepare for segmentation correction
    set(gcf,'WindowButtonDownFcn',{@figure2_WindowButtonDownFcn,handles});
    set(gcf,'WindowButtonMotionFcn',{@figure2_WindowButtonMotionFcn,handles});
    set(gcf,'WindowButtonUpFcn',{@figure2_WindowButtonUpFcn,handles}); 
end


%%%%% parameter for the BrushSize %%%%%%
% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
x=round(get(hObject,'Value'));
handles.Brush = 2*x+1;
set(handles.BrushSize,'String',num2str(handles.Brush));
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% program options %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% --- Executes on button press in consecutive.
function consecutive_Callback(hObject, eventdata, handles)
% hObject    handle to consecutive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of consecutive
handles = guidata(hObject);
val = get(hObject,'Value');
if val == 1
    handles.consecutive = 1;
else
    handles.consecutive= 0;
end
guidata(hObject, handles);

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

if(~isfield(handles,'FileName') || ~isfield(handles,'Max'))
    return
end

val = str2double(get(hObject,'String'));
if val < 1 || val > handles.Max
    msgbox(['Invalid trajecotry index, the max value is ',num2str(handles.Max)],'Error','error');
else
    handles.certainidx = val;
    guidata(hObject, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Save all 
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
        [FileName,PathName] = uiputfile('*.mat','Select output location');
        
        handles = guidata(hObject);
        cellEachFrame = handles.cellEachFrame;
        idEachFrame = handles.idEachFrame;
        matEachFrame = handles.matEachFrame;
        rawEachFrame = handles.rawEachFrame;
        save([PathName,FileName],'cellEachFrame','idEachFrame','matEachFrame','rawEachFrame');
        msgbox('save successfully ^_^','Infor');
        guidata(hObject, handles);
    case 'No'
        return
end


%%%%%% Exit safely
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
        return
end
