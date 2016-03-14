function [ texturedimage1 ] = pixelcompare( image )
%This function takes difference between the center pixel and
% 8 neighbour pixels and basing on negative sign or positive sign

texturedimage=imresize(image,[400,400]);
if (size(texturedimage,3) == 1)
    texturedimage = cat(3,texturedimage,texturedimage,texturedimage);
end
texturedimage1 = double(rgb2gray(texturedimage))/255;

%firstpart

for j=2:399
    for i=2:399
        
        a=texturedimage1(i,j);
        a=a*0.65;
        a1=a-texturedimage1(i-1,j-1);
        a2=a-texturedimage1(i-1,j);
        a3=a-texturedimage1(i-1,j+1);
        a4=a-texturedimage1(i,j-1);
        a5=a-texturedimage1(i,j+1);
        a6=a-texturedimage1(i+1,j-1);
        a7=a-texturedimage1(i+1,j);
        a8=a-texturedimage1(i+1,j+1);
        
        diff=[a1,a2,a3,a4,a5,a6,a7,a8];
        %[~,I]=sort(diff,'descend');
        
        % for i=1:8
        %     if I(i)==1;
        %         image
        %
        %     end
        
        if diff(1)>0
            texturedimage1(i-1,j-1)=0;
        else
            texturedimage1(i-1,j-1)=1;
        end
        
        if diff(2)>0
            texturedimage1(i-1,j)=0;
        else
            texturedimage1(i-1,j)=1;
            
        end
        if diff(3)>0
            texturedimage1(i-1,j+1)=0;
        else
            texturedimage1(i-1,j+1)=1;
        end
        if diff(4)>0
            texturedimage1(i,j-1)=0;
        else
            texturedimage1(i,j-1)=1;
        end
        if diff(5)>0
            texturedimage1(i,j+1)=0;
        else
            texturedimage1(i,j+1)=1;
        end
        if diff(6)>0
            texturedimage1(i+1,j-1)=0;
        else
            texturedimage1(i+1,j-1)=1;
        end
        if diff(7)>0
            texturedimage1(i+1,j)=0;
        else
            texturedimage1(i+1,j)=1;
        end
        
        if diff(8)>0
            texturedimage1(i+1,j+1)=0;
        else
            texturedimage1(i+1,j+1)=1;
        end
        
        

    end
end


end

