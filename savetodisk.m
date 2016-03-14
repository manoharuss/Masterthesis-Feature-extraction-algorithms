clc; clear all; close all;

%Read the HTML file with the 100image links
HTMLfile= fileread('C:\Users\Manu\Desktop\full map of india.html');

% We will search and split the HTML file data where the links ARE
%So the output will be a string with 101 columns with each element from 2nd
%will start with a link
Splitsect = strsplit(HTMLfile,'www.google.com/imgres?imgurl=');

%Change directory here
save2folder='C:\Users\Manu\Desktop\India\';
mkdir(save2folder);
%This loop will split the links from the correspoding arrays and then store
%them sequentially into the LINKS array.
Links{100,1}=[];
for i=2:101
    
    Temp1 = num2str(cell2mat(Splitsect(1,(i))));
    Temp2 = strsplit (Temp1,'&amp');
    Links((i)-1,1)=Temp2(1,1);
        
end


%Links are already there by now, we have to read and write them to files

i=1;
BaseName='\Image';

for i=1:100
    img=[];
    url=num2str(cell2mat(Links((i),1)));
    try
        img=imread(url);
    catch exception
    end
    
    if ~isempty(img)
        FileName=[BaseName,num2str(i)];
        directory=strcat(save2folder,FileName,'.jpg');
        try imwrite(img, directory);
        catch exception
        end
    end
    
end

       

