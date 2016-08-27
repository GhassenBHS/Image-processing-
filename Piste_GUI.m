function varargout = Piste_GUI(varargin)
% PISTE_GUI MATLAB code for Piste_GUI.fig
%      PISTE_GUI, by itself, creates a new PISTE_GUI or raises the existing
%      singleton*.
%
%      H = PISTE_GUI returns the handle to a new PISTE_GUI or the handle to
%      the existing singleton*.
%
%      PISTE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PISTE_GUI.M with the given input arguments.
%
%      PISTE_GUI('Property','Value',...) creates a new PISTE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Piste_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Piste_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Piste_GUI

% Last Modified by GUIDE v2.5 23-Apr-2016 23:00:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Piste_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Piste_GUI_OutputFcn, ...
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


% --- Executes just before Piste_GUI is made visible.
function Piste_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Piste_GUI (see VARARGIN)

% Choose default command line output for Piste_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Piste_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global finished;
global m;
m = zeros(20,20);
finished=false ;


% --- Outputs from this function are returned to the command line.
function varargout = Piste_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function numberIteration_Callback(hObject, eventdata, handles)
% hObject    handle to numberIteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberIteration as text
%        str2double(get(hObject,'String')) returns contents of numberIteration as a double


% --- Executes during object creation, after setting all properties.
function numberIteration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberIteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resizeFactor_Callback(hObject, eventdata, handles)
% hObject    handle to resizeFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resizeFactor as text
%        str2double(get(hObject,'String')) returns contents of resizeFactor as a double


% --- Executes during object creation, after setting all properties.
function resizeFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resizeFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)

global finished ;
global m;
if isfield(handles, 'img') & ~finished

if  ~isequal(m, zeros(20,20))

smth=get(handles.smooth, 'string');
smooth= str2num(smth);
if ( isempty(smooth) )
  smooth=.2 ;
end
img=handles.img;
img_copy=img;
m=handles.m;
str=get(handles.numberIteration, 'string');
num= str2num(str);
if ( isempty(num) )
 h = msgbox('Please enter Iterations number', 'Error','error');
 return;
end
str1=get(handles.resizeFactor, 'string');
factor= str2num(str1);
%resizing
if factor<=1 & factor>0 & ~isempty(factor) 
img_copy = imresize(img_copy,factor);  %-- make image smaller 
m = imresize(m,factor); 
 
end
seg = region_seg(img_copy, m, num,smooth);
se = strel(ones(6,6));
seg=imdilate(seg, se);
axes(handles.axes2) ;
imshow(seg);
handles.seg=seg;
guidata(hObject,handles);
finished=true ;
else
     h = msgbox(' Double Click to run', 'Error','error');
end
else
    h = msgbox(' Can''t Run,Upload Image First', 'Error','error');
end
% --- Executes on button press in UploadImage.
function UploadImage_Callback(hObject, eventdata, handles)
cla ;
global finished ;
global m;
m= zeros(20,20);
[filename, pathname] = uigetfile({'*.jpg','Jpg (*.jpg)';'*.png','Png (*.png)';...
                    '*.bmp','Bmp (*.bmp)';'*.tif','Tif (*.tif)';...
                    '*.gif','Gif (*.gif)'}, 'Pick an Image File');
if pathname==0, return; end 
img=imread([pathname,filename]);
axes(handles.uploadedImage)
imshow(img);
handles.img=img;
guidata(hObject,handles);
finished=false ;


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)

if isfield(handles, 'seg')    
seg=handles.seg;
[filename, pathname] = uiputfile({'*.png','Png (*.png)';...
                    '*.bmp','Bmp (*.bmp)';'*.tif','Tif (*.tif)';...
                    '*.gif','Gif (*.gif)';'*.jpg','Jpg (*.jpg)'},'Save as');
                if ( ~isempty(pathname) && ~isempty(filename) )
                    imwrite(seg,[pathname filename]);
               
                end
                 
                
else 
 h = msgbox(' Can''t save', 'Error','error');   
end
% --- Executes on button press in MakeContour.
function MakeContour_Callback(hObject, eventdata, handles)

global finished ;
global m;
if isfield(handles, 'img') && ~finished 
    if  isequal(m, zeros(20,20))



%recupérer l'image    

img=handles.img;

m=FreehandMasking(img,1);
%Sauvegarder le output mask
handles.m=m;
guidata(hObject,handles);
    else
      h = msgbox('You Already made a contour,Re-upload to make another one', 'Error','error');  
    end
else
   h = msgbox(' Can''t Make Contour,Upload Image First', 'Error','error');   
   
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)

close(gcbf);
Piste_GUI ;
%clf('reset') ;



function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smooth as text
%        str2double(get(hObject,'String')) returns contents of smooth as a double


% --- Executes during object creation, after setting all properties.
function smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
