function varargout = GUIFinal(varargin)
% This is a Main Matlab code for the figure GUIFINAL as part of the Master
% thesis "Content based Image retrieval using latest methods"
% academic work of Manohar Erikipati, GEOENGINE, University of Stuttgart
% Supervisor Dr.Volker Walter
%Use this m file in tandem with the GUIfile to avoid frustration
%The code for reading image data and reading user input starts from serial line 110 in this file



% For help understanding the code, please follow the report





% Matlab help available for: GUIDE, GUIDATA, GUIHANDLES
% Last Modified by GUIDE v2.5 14-May-2015 16:15:39

%% This code is to initialize the GUI - PLEASE DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIFinal_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIFinal_OutputFcn, ...
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
% End initialization code - PLEASE DO NOT EDIT


% --- Executes just before GUIFinal is made visible.
function GUIFinal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIFinal (see VARARGIN)

% Choose default command line output for GUIFinal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIFinal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIFinal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in showimage1.
function showimage1_Callback(hObject, eventdata, handles)
% hObject    handle to showmage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path1=get(handles.pathedit,'string');
inputnumber=get(handles.edit1,'string');
path=strcat(path1,'/Image',inputnumber,'.jpg');
image=imread(path);
imageshow=im2double(image);
axes(handles.axes1);
imshow(imageshow);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in selectdisimage.
function selectdisimage_Callback(hObject, eventdata, handles)
% hObject    handle to selectdisimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of selectdisimage


% --- Executes on button press in performall.
function performall_Callback(hObject, eventdata, handles)
%This function performs all the necessary fucntions the user has selected
%in the GUI for CBIR

status='Processing...';
set(handles.statustext, 'String', status)
%%%%%%%%%%%%%%%%
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%%%%%%%%%%%%%%%


%%%Reading the image
path1=get(handles.pathedit,'string');
inputnumber=get(handles.edit1,'string');
path=strcat(path1,'/Image',inputnumber,'.jpg');
selimage=imread(path);

%%%Reading the buttons
histogram=get(handles.histogramproc,'Value');
edgedetect=get(handles.edgedetect,'Value');
hsv=get(handles.hsvbutton,'Value');
regionblocks=get(handles.regionsbutton,'Value');
signop=get(handles.signbutton,'Value');
magnitude=get(handles.magnitudebutton,'Value');
signmag=get(handles.signmagbutton,'Value');




%% This part is for image processing
%First is plain histogram for images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HISTOGRAM%%%%%%%%%%%%%
parts=get(handles.histparts,'string');
parts=str2double(parts);
if histogram == 1
    
    %Get the number of parts given by the user
    
    hist1=imageparts(selimage,parts);
    
    %start the loop now
    
    score=zeros(100,1);
    for i=1:100
        path3=int2str(i);
        path=strcat(path1,'/Image',path3,'.jpg'); %building path for each image -i iterated from 1 to 100
        
        imagiter=[];
        
        try
            imagiter=imread(path); %reading image from the path
        catch exception
        end
        
        if ~isempty(imagiter)
            
            [ihist]=imageparts(imagiter,parts);
            result= matrixcompare(hist1,ihist);
            score(i,1)=result;
            
        else
            score(i,1)=100000;%Should be doing nothing
        end
        
    end
    %This part is for saving to directory
    
    clear imagiter
    [~,I] = sort(score); %I is the index for histogram here
    direc1=strcat(path1,'/Histogram');
    
    try
        rmdir(direc1,'s');
    catch exception
    end
    
    mkdir(direc1);
    
    for j=1:100
        path3=num2str(I(j,1));
        path=strcat(path1,'/Image',path3,'.jpg');
        try
            imagiter=imread(path);
        catch exception
            
        end
        if ~isempty(exception)
            
            direc2=num2str(j);
            directory=strcat(direc1,'/Image',direc2,'.jpg');
            
            imwrite(imagiter,directory);
        end
        
    end
    
    
end
%% END OF HISTOGRAM%%%%%%%

clear direc1 direc2 directory I result score
%% EDGE DETECTION%%%%%%%%%%%%%%%%%%%%%%%
%This part is where the edge detection. We are using sobel method.


if edgedetect == 1
    
    
    %Write the whole edgedetect inside this
    
    edges1=imageedgedetect(selimage);
    E=imageparts(edges1,parts);
    
    score=zeros(100,1);
    for i=1:100
        path3=int2str(i);
        path=strcat(path1,'/Image',path3,'.jpg'); %building path for each image -i iterated from 1 to 100
        
        imagiter=[];
        
        try
            imagiter=imread(path); %reading image from the path
        catch exception
        end
        
        if ~isempty(imagiter)
                    
            edges=imageedgedetect(imagiter);
            [N]=imageparts(edges,parts);            
            result= matrixcompare(E,N); %here first variable is global which should be taken from select image
            score(i,1)=result;
            
        else
            score(i,1)=1000;
        end
        
    end
    
    
    
    %%%Saving to directory the results
    [~,I] = sort (score);
    
    clear path result N E imagiter edges path3 i score
    direc1=strcat(path1,'/EdgeDetection');
    
    try
        rmdir(direc1,'s');
    catch exception
    end
    
    mkdir(direc1);
    
    
    for j=1:100
        path3=num2str(I(j,1));
        path=strcat(path1,'/Image',path3,'.jpg');
        try
            imagiter=imread(path);
        catch exception
                       
        end
        if ~isempty(exception)
            
            direc2=num2str(j);
            directory=strcat(direc1,'/Image',direc2,'.jpg');
            
            imwrite(imagiter,directory);
        end
        
    end
    
end

%% END OF EDGE DETECTION%%%%%%%%%%%%%%%%

clear exception direc1 direc2 directory I result path path3
%% HSV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if hsv == 1
    
    %This is to get the number of classes of HSV from the GUI from the user
    hclasses=get(handles.hclasses,'string');
    hclasses=str2double(hclasses);
    sclasses=get(handles.sclasses,'string');
    sclasses=str2double(sclasses);
    vclasses=get(handles.vclasses,'string');
    vclasses=str2double(vclasses);
    
    %We need to get the hsv vector of the selected image first to compare with
    %others
    
    hsv1=hsvclassification(selimage,hclasses,sclasses,vclasses);

    
    %Write the whole HSV inside this
    score=zeros(100,1);
    for i=1:100
        path3=int2str(i);
        path=strcat(path1,'/Image',path3,'.jpg'); %building path for each image -i iterated from 1 to 100
        imagiter=[];
        try
            imagiter=imread(path); %reading image from the path
        catch exception
        end
        
        if ~isempty(imagiter)
                    
            selblock2=hsvclassification(imagiter,hclasses,sclasses,vclasses);
            result= matrixcompare(hsv1,selblock2); %here first variable is global which should be taken from select image
            score(i,1)=result;
            
        else
            score(i,1)=1000;
        end
        
    end
    
    [~,I] = sort (score);
    
    
    direc1=strcat(path1,'/HSV');
    
    try
        rmdir(direc1,'s');
    catch exception
    end
    
    mkdir(direc1);
    
    
    for j=1:100
        path3=num2str(I(j,1));
        path=strcat(path1,'/Image',path3,'.jpg');
        try
            imagiter=imread(path);
        catch exception
            
            
        end
        if ~isempty(exception)
            
            direc2=num2str(j);
            directory=strcat(direc1,'/Image',direc2,'.jpg');
            
            imwrite(imagiter,directory);
        end
        
    end
    
end
%% End of HSV%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear direc1 direc2 directory I result imagiter path3 path

%% Regionblocks%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if regionblocks == 1
    
    selimage=imresize(selimage,[600 600]);
    [selblock1]=blockcompare(selimage);
    [histblock1]=imageparts(selblock1,parts);
    
    %The whole program for region blocks is here
    score=zeros(100,1);
    for i=1:100
        path3=int2str(i);
        path=strcat(path1,'/Image',path3,'.jpg'); %building path for each image -i iterated from 1 to 100
        imagiter=[];
        try
            imagiter=imread(path); %reading image from the path
        catch exception
        end
        
        if ~isempty(imagiter)
                    
            imagiter=imresize(imagiter,[600 600]);
            selblock2=blockcompare(imagiter);
            histblock2=imageparts(selblock2,parts);
            result= matrixcompare(histblock1,histblock2); %here first variable is global which should be taken from select image
            score(i,1)=result;
            
        else
            score(i,1)=100000;
        end
        
    end
    
    [~,I] = sort (score);
    
    
    direc1=strcat(path1,'/Regions');
    
    try
        rmdir(direc1,'s');
    catch exception
    end
    
    mkdir(direc1);
    
    
    for j=1:100
        path3=num2str(I(j,1));
        path=strcat(path1,'/Image',path3,'.jpg');
        try
            imagiter=imread(path);
        catch exception
            
            
        end
        if ~isempty(exception)
            
            direc2=num2str(j);
            directory=strcat(direc1,'/Image',direc2,'.jpg');
            
            imwrite(imagiter,directory);
        end
        
    end
    
end
%% End of Region blocks here%%%%%%%%%%%%%%%%%%%%%%%
clear direc1 direc2 directory I result imagiter path3 path

%% Texture SIGN Operator


if signop == 1
    
    [sign1]=pixelcompare(selimage);
    
    %The whole program for sign operator is here
    score=zeros(100,1);
    for i=1:100
        path3=int2str(i);
        path=strcat(path1,'/Image',path3,'.jpg'); %building path for each image -i iterated from 1 to 100
        imagiter=[];
        try
            imagiter=imread(path); %reading image from the path
        catch exception
        end
        
        if ~isempty(imagiter)
                    
            sign2=pixelcompare(imagiter);
            result= doubleimagecompare(sign1,sign2); %here first variable is global which should be taken from select image
            score(i,1)=result;
            
        else
            score(i,1)=1000;
        end
        
    end
    
    [~,I] = sort (score);
    
    
    direc1=strcat(path1,'/SignOp');
    
    try
        rmdir(direc1,'s');
    catch exception
    end
    
    mkdir(direc1);
    
    
    for j=1:100
        path3=num2str(I(j,1));
        path=strcat(path1,'/Image',path3,'.jpg');
        try
            imagiter=imread(path);
        catch exception
            
            
        end
        if ~isempty(exception)
            
            direc2=num2str(j);
            directory=strcat(direc1,'/Image',direc2,'.jpg');
            
            imwrite(imagiter,directory);
        end
        
    end
    
end

%%End of SIGN Operator%%%%%%%%%%%%
clear direc1 direc2 directory I result imagiter path3 path

%% Magnitude operator%%%%%%%%%%%%%%%%%%%%%%

if magnitude == 1
    
    signcoeff=get(handles.acoeff,'string');
    signcoeff=str2double(signcoeff);
    magcoeff=get(handles.bcoeff,'string');
    magcoeff=str2double(magcoeff);
    [mag1]=pixelmagnitudecompare(selimage,signcoeff,magcoeff);

    %The whole program for magnitude operator is here
    score=zeros(100,1);
    for i=1:100
        path3=int2str(i);
        path=strcat(path1,'/Image',path3,'.jpg'); %building path for each image -i iterated from 1 to 100
        imagiter=[];
        try
            imagiter=imread(path); %reading image from the path
        catch exception
        end
        
        if ~isempty(imagiter)
                    
            mag2=pixelmagnitudecompare(imagiter,signcoeff,magcoeff);
            result= doubleimagecompare(mag1,mag2); %here first variable is global which should be taken from select image
            score(i,1)=result;
            
        else
            score(i,1)=1000;
        end
        
    end
    
    [~,I] = sort (score);
    
    
    direc1=strcat(path1,'/MagOp');
    
    try
        rmdir(direc1,'s');
    catch exception
    end
    
    mkdir(direc1);
    
    
    for j=1:100
        path3=num2str(I(j,1));
        path=strcat(path1,'/Image',path3,'.jpg');
        try
            imagiter=imread(path);
        catch exception
            
            
        end
        if ~isempty(exception)
            
            direc2=num2str(j);
            directory=strcat(direc1,'/Image',direc2,'.jpg');
            
            imwrite(imagiter,directory);
        end
        
    end
    
end

%% End of Magnitude%%%%%%%%%%%%%%%%%%%%%%%%%%
clear direc1 direc2 directory I result imagiter path3 path

%% Sign +Magnitude operator starts here%%%%%%%%%%%%%%


if signmag == 1
    signcoeff=get(handles.signcoeff,'string');
    signcoeff=str2double(signcoeff);
    magcoeff=get(handles.magcoeff,'string');
    magcoeff=str2double(magcoeff);
    [sign1]=pixelcompare(selimage);
    [mag1]=pixelmagnitudecompare(selimage,signcoeff,magcoeff);
    
    %The whole program for magnitude operator is here
    score=zeros(100,1);
    for i=1:100
        path3=int2str(i);
        path=strcat(path1,'/Image',path3,'.jpg'); %building path for each image -i iterated from 1 to 100
        imagiter=[];
        try
            imagiter=imread(path); %reading image from the path
        catch exception
        end
        
        if ~isempty(imagiter)
            sign2=pixelcompare(imagiter);        
            mag2=pixelmagnitudecompare(imagiter,signcoeff,magcoeff);
            result1= doubleimagecompare(sign1,sign2);
            result2= doubleimagecompare(mag1,mag2); %here first variable is global which should be taken from select image
            result=signcoeff*result1+magcoeff*result2;
            score(i,1)=result;
            
        else
            score(i,1)=100000;
        end
        
    end
    
    [~,I] = sort (score);
    
    
    direc1=strcat(path1,'/Sign&Mag');
    
    try
        rmdir(direc1,'s');
    catch exception
    end
    
    mkdir(direc1);
    
    
    for j=1:100
        path3=num2str(I(j,1));
        path=strcat(path1,'/Image',path3,'.jpg');
        try
            imagiter=imread(path);
        catch exception
            
            
        end
        if ~isempty(exception)
            
            direc2=num2str(j);
            directory=strcat(direc1,'/Image',direc2,'.jpg');
            
            imwrite(imagiter,directory);
        end
        
    end
    
end

%% End of sign + Magnitude%%%%%%%%%%%%%%%%%%%%%%%%%%
clear direc1 direc2 directory I result imagiter path3 path score sign2 mag2

status='Done!';
set(handles.statustext, 'String', status)



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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%Reading the buttons
histogram=get(handles.histdisplay,'Value');
edgedetect=get(handles.edgedetectdisplay,'Value');
hsv=get(handles.hsvdisplay,'Value');
regionblocks=get(handles.blockdisplay,'Value');
signop=get(handles.signdisplay,'Value');
magnitude=get(handles.magdisplay,'Value');
signmag=get(handles.signmagdisplay,'Value');


path1=get(handles.pathedit,'string');
number=get(handles.edit2,'string');
%This is to display histogram results
if histogram==1
    displaydirec=strcat(path1,'/Histogram/Image',number,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes2);
    imshow(sequence1);
    
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/Histogram/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Histogram/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Histogram/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Histogram/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Histogram/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Histogram/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes8);
    imshow(sequence1);
end

%%%%%%%%%This is to display edgedetection results
if edgedetect==1
    displaydirec=strcat(path1,'/EdgeDetection/Image',number,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes2);
    imshow(sequence1);
    
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes8);
    imshow(sequence1);
end
%This is to display HSV results
if hsv==1
    displaydirec=strcat(path1,'/HSV/Image',number,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes2);
    imshow(sequence1);
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/HSV/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/HSV/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/HSV/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/HSV/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/HSV/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/HSV/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes8);
    imshow(sequence1);
end
%This is to display region block results
if regionblocks==1
    displaydirec=strcat(path1,'/Regions/Image',number,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes2);
    imshow(sequence1);
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/Regions/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes8);
    imshow(sequence1);
end
%This is to display sign operator results
if signop==1
    displaydirec=strcat(path1,'/SignOp/Image',number,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes2);
    imshow(sequence1);
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/SignOp/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes8);
    imshow(sequence1);
end
%This is to display Magnitude operator results
if magnitude==1
    displaydirec=strcat(path1,'/MagOp/Image',number,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes2);
    imshow(sequence1);
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/MagOp/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes8);
    imshow(sequence1);
    
end
%This is to display Sign+Magnitude operator results
if signmag==1
    displaydirec=strcat(path1,'/Sign&Mag/Image',number,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes2);
    imshow(sequence1);
    
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/Sign&Mag/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Sign&Mag/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Sign&Mag/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Sign&Mag/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Sign&Mag/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Sign&Mag/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    sequence1=im2double(sequence);
    axes(handles.axes8);
    imshow(sequence1);
end





% --- Executes during object creation, after setting all properties.
function pushbutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in getpath.
function getpath_Callback(hObject, eventdata, handles)
% hObject    handle to getpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in histogramproc.
function histogramproc_Callback(hObject, eventdata, handles)
% hObject    handle to histogramproc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of histogramproc


% --- Executes on button press in edgedetect.
function edgedetect_Callback(hObject, eventdata, handles)
% hObject    handle to edgedetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edgedetect



% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in histdisplay.
function histdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to histdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of histdisplay



% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7



function pathedit_Callback(hObject, eventdata, handles)
% hObject    handle to pathedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathedit as text
%        str2double(get(hObject,'String')) returns contents of pathedit as a double


% --- Executes during object creation, after setting all properties.
function pathedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hsvbutton.
function hsvbutton_Callback(hObject, eventdata, handles)
% hObject    handle to hsvbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hsvbutton


% --- Executes on button press in signbutton.
function signbutton_Callback(hObject, eventdata, handles)
% hObject    handle to signbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of signbutton


% --- Executes on button press in magnitudebutton.
function magnitudebutton_Callback(hObject, eventdata, handles)
% hObject    handle to magnitudebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of magnitudebutton


% --- Executes on button press in regionsbutton.
function regionsbutton_Callback(hObject, eventdata, handles)
% hObject    handle to regionsbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of regionsbutton




% --- Executes on button press in flip1.
function flip1_Callback(hObject, eventdata, handles)
% hObject    handle to flip1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%Reading the buttons
edgedetect=get(handles.edgedetectdisplay,'Value');
regionblocks=get(handles.blockdisplay,'Value');
signop=get(handles.signdisplay,'Value');
magnitude=get(handles.magdisplay,'Value');

%For the principle image
path1=get(handles.pathedit,'string');
number=get(handles.edit1,'string');
%This is to display edgedetection results
if edgedetect==1
    displaydirec=strcat(path1,'Image',number,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes1);
    imshow(sequence1);
end
%This is to display region block results
if regionblocks==1
    displaydirec=strcat(path1,'Image',number,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes1);
    imshow(sequence1);
end
%This is to display sign operator results
if signop==1
    displaydirec=strcat(path1,'Image',number,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes1);
    imshow(sequence1);
end

%This is to display Magnitude operator results
if magnitude==1
    a=get(handles.acoeff,'string');
    a=str2double(a);
    b=get(handles.bcoeff,'string');
    b=str2double(b);
    displaydirec=strcat(path1,'Image',number,'.jpg');
    sequence=imread(displaydirec);
    magimage=pixelmagnitudecompare(sequence,a,b);
    sequence1=im2double(magimage);
    axes(handles.axes1);
    imshow(sequence1);
end

% --- Executes on button press in flip2.
function flip2_Callback(hObject, eventdata, handles)
% hObject    handle to flip2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%Reading the buttons

edgedetect=get(handles.edgedetectdisplay,'Value');
regionblocks=get(handles.blockdisplay,'Value');
signop=get(handles.signdisplay,'Value');
magnitude=get(handles.magdisplay,'Value');
%%%Reading the image
path1=get(handles.pathedit,'string');
number=get(handles.edit2,'string');
%This is to display edgedetection results
if edgedetect==1
    displaydirec=strcat(path1,'/EdgeDetection/Image',number,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes2);
    imshow(sequence1);
    
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/EdgeDetection/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    BW=imageedgedetect(sequence);
    sequence1=im2double(BW);
    axes(handles.axes8);
    imshow(sequence1);
end
%This is to display region block results
if regionblocks==1
    displaydirec=strcat(path1,'/Regions/Image',number,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes2);
    imshow(sequence1);
    
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/Regions/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/Regions/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    selectblock=blockcompare(sequence);
    sequence1=im2double(selectblock);
    axes(handles.axes8);
    imshow(sequence1);
end
%This is to display sign operator results
if signop==1
    displaydirec=strcat(path1,'/SignOp/Image',number,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes2);
    imshow(sequence1);
    
    
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/SignOp/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/SignOp/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes8);
    imshow(sequence1);
end

%This is to display Magnitude operator results
if magnitude==1
    a=get(handles.acoeff,'string');
    a=str2double(a);
    b=get(handles.bcoeff,'string');
    b=str2double(b);
    displaydirec=strcat(path1,'/MagOp/Image',number,'.jpg');
    sequence=imread(displaydirec);
    magimage=pixelmagnitudecompare(sequence,a,b);
    sequence1=im2double(magimage);
    axes(handles.axes2);
    imshow(sequence1);
    
    
    %This below code is for the below display of images
    number=str2double(number)+1;
    number2=number+1;
    number2=num2str(number2);
    number3=number+2;
    number3=num2str(number3);
    number4=number+3;
    number4=num2str(number4);
    number5=number+4;
    number5=num2str(number5);
    number6=number+5;
    number6=num2str(number6);
    number1=num2str(number);
    displaydirec=strcat(path1,'/MagOp/Image',number1,'.jpg');
    sequence=imread(displaydirec);
    magimage=pixelmagnitudecompare(sequence,a,b);
    sequence1=im2double(magimage);
    axes(handles.axes3);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number2,'.jpg');
    sequence=imread(displaydirec);
    magimage=pixelmagnitudecompare(sequence,a,b);
    sequence1=im2double(magimage);
    axes(handles.axes4);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number3,'.jpg');
    sequence=imread(displaydirec);
    magimage=pixelmagnitudecompare(sequence,a,b);
    sequence1=im2double(magimage);
    axes(handles.axes5);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number4,'.jpg');
    sequence=imread(displaydirec);
    signimage= pixelcompare(sequence);
    sequence1=im2double(signimage);
    axes(handles.axes6);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number5,'.jpg');
    sequence=imread(displaydirec);
    magimage=pixelmagnitudecompare(sequence,a,b);
    sequence1=im2double(magimage);
    axes(handles.axes7);
    imshow(sequence1);
    displaydirec=strcat(path1,'/MagOp/Image',number6,'.jpg');
    sequence=imread(displaydirec);
    magimage=pixelmagnitudecompare(sequence,a,b);
    sequence1=im2double(magimage);
    axes(handles.axes8);
    imshow(sequence1);
end


function histparts_Callback(hObject, eventdata, handles)
% hObject    handle to histparts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of histparts as text
%        str2double(get(hObject,'String')) returns contents of histparts as a double


% --- Executes during object creation, after setting all properties.
function histparts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to histparts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hclasses_Callback(hObject, eventdata, handles)
% hObject    handle to hclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hclasses as text
%        str2double(get(hObject,'String')) returns contents of hclasses as a double


% --- Executes during object creation, after setting all properties.
function hclasses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sclasses_Callback(hObject, eventdata, handles)
% hObject    handle to sclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sclasses as text
%        str2double(get(hObject,'String')) returns contents of sclasses as a double


% --- Executes during object creation, after setting all properties.
function sclasses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vclasses_Callback(hObject, eventdata, handles)
% hObject    handle to vclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vclasses as text
%        str2double(get(hObject,'String')) returns contents of vclasses as a double


% --- Executes during object creation, after setting all properties.
function vclasses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function acoeff_Callback(hObject, eventdata, handles)
% hObject    handle to acoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acoeff as text
%        str2double(get(hObject,'String')) returns contents of acoeff as a double


% --- Executes during object creation, after setting all properties.
function acoeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bcoeff_Callback(hObject, eventdata, handles)
% hObject    handle to bcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bcoeff as text
%        str2double(get(hObject,'String')) returns contents of bcoeff as a double


% --- Executes during object creation, after setting all properties.
function bcoeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in signmagbutton.
function signmagbutton_Callback(hObject, eventdata, handles)
% hObject    handle to signmagbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: get(hObject,'Value') returns toggle state of signmagbutton



function signcoeff_Callback(hObject, eventdata, handles)
% hObject    handle to signcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of signcoeff as text
%        str2double(get(hObject,'String')) returns contents of signcoeff as a double


% --- Executes during object creation, after setting all properties.
function signcoeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function magcoeff_Callback(hObject, eventdata, handles)
% hObject    handle to magcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of magcoeff as text
%        str2double(get(hObject,'String')) returns contents of magcoeff as a double


% --- Executes during object creation, after setting all properties.
function magcoeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magcoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function histogramproc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to histogramproc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on histogramproc and none of its controls.
function histogramproc_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to histogramproc (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in signmagdisplay.
function signmagdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to signmagdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of signmagdisplay


% --- Executes on button press in hsvdisplay.
function hsvdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to hsvdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of hsvdisplay


% --- Executes on button press in blockdisplay.
function blockdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to blockdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of blockdisplay


% --- Executes on button press in signdisplay.
function signdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to signdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of signdisplay


% --- Executes on button press in magdisplay.
function magdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to magdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of magdisplay


% --- Executes on key press with focus on performall and none of its controls.
function performall_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to performall (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over performall.
function performall_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to performall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uibuttongroup1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over histdisplay.
function histdisplay_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to histdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on histdisplay and none of its controls.
function histdisplay_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to histdisplay (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton3 and none of its controls.
function pushbutton3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton3.
function pushbutton3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in edgedetectdisplay.
function edgedetectdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to edgedetectdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of edgedetectdisplay
