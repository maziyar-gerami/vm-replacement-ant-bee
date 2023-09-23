function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 24-Jun-2016 17:15:53

% Begin initialization code - DO NOT EDIT




gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)
% Initial Random Vms
rng(14);
nVms = 20;
handles.VMs.Name = {'D1' 'D2' 'D3' 'D4' 'D11' 'D12' 'D13' 'D14'};
handles.VMs.Cores = [ 1 2 4 8 2 4 8 16];
handles.VMs.Ram = [3.5, 7, 14, 28, 14,28,56, 112];
handles.VMs.Bandwidth = [1000, 1000, 1000, 1000, 1000,1000,1000, 1000];

VmsTypes = length (handles.VMs.Cores);  
handles.CreatedVMs= randi(VmsTypes, 1 , nVms);
[WA, handles.numberOfeachVm] = ACO_BA(handles.CreatedVMs);
set(findobj('Tag', 'txtWastage'), 'String', WA);

set(findobj('Tag', 'txtD1'), 'String', handles.numberOfeachVm(1));
set(findobj('Tag', 'txtD2'), 'String', handles.numberOfeachVm(2));
set(findobj('Tag', 'txtD3'), 'String', handles.numberOfeachVm(3));
set(findobj('Tag', 'txtD4'), 'String', handles.numberOfeachVm(4));
set(findobj('Tag', 'txtD11'), 'String', handles.numberOfeachVm(5));
set(findobj('Tag', 'txtD12'), 'String', handles.numberOfeachVm(6));
set(findobj('Tag', 'txtD13'), 'String', handles.numberOfeachVm(7));
set(findobj('Tag', 'txtD14'), 'String', handles.numberOfeachVm(8));




% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in addBtn.
function addBtn_Callback(hObject, eventdata, handles)
% hObject    handle to addBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected = get((findobj('Tag', 'popupmenu1')), 'Value');
%selected = cell2mat(selected(1));
handles.CreatedVMs(end+1) = selected;

[WA, handles.numberOfeachVm] = ACO_BA(handles.CreatedVMs);
set(findobj('Tag', 'txtWastage'), 'String', WA);

set(findobj('Tag', 'txtD1'), 'String', handles.numberOfeachVm(1));
set(findobj('Tag', 'txtD2'), 'String', handles.numberOfeachVm(2));
set(findobj('Tag', 'txtD3'), 'String', handles.numberOfeachVm(3));
set(findobj('Tag', 'txtD4'), 'String', handles.numberOfeachVm(4));
set(findobj('Tag', 'txtD11'), 'String', handles.numberOfeachVm(5));
set(findobj('Tag', 'txtD12'), 'String', handles.numberOfeachVm(6));
set(findobj('Tag', 'txtD13'), 'String', handles.numberOfeachVm(7));
set(findobj('Tag', 'txtD14'), 'String', handles.numberOfeachVm(8));

guidata(hObject, handles);





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected = get((findobj('Tag', 'popupmenu1')), 'Value');
%selected = cell2mat(selected(1));
for i=1:length (handles.CreatedVMs);
    
    if selected== handles.CreatedVMs(i)
        handles.CreatedVMs(i) = [];
        break;
        
    end
   
    
end

[WA, handles.numberOfeachVm] = ACO_BA(handles.CreatedVMs);
set(findobj('Tag', 'txtWastage'), 'String', WA);

set(findobj('Tag', 'txtD1'), 'String', handles.numberOfeachVm(1));
set(findobj('Tag', 'txtD2'), 'String', handles.numberOfeachVm(2));
set(findobj('Tag', 'txtD3'), 'String', handles.numberOfeachVm(3));
set(findobj('Tag', 'txtD4'), 'String', handles.numberOfeachVm(4));
set(findobj('Tag', 'txtD11'), 'String', handles.numberOfeachVm(5));
set(findobj('Tag', 'txtD12'), 'String', handles.numberOfeachVm(6));
set(findobj('Tag', 'txtD13'), 'String', handles.numberOfeachVm(7));
set(findobj('Tag', 'txtD14'), 'String', handles.numberOfeachVm(8));
guidata(hObject, handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selected = get((findobj('Tag', 'popupmenu1')), 'Value');
%selected = cell2mat(selected(1));
set((findobj('Tag', 'textCore')), 'String',handles.VMs.Cores(selected));
set((findobj('Tag', 'textRam')), 'String',handles.VMs.Ram(selected));
set((findobj('Tag', 'textBW')), 'String',handles.VMs.Bandwidth(selected));


% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
