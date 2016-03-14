function [ texturedimage1 ] = pixelmagnitudecompare( image,a,b )
%This function is based on comparison of mean of the complete image and magnitude of each 9 pixel set

texturedimage=imresize(image,[400,400]);


if size(texturedimage, 3) ==1
    texturedimage=cat(3, texturedimage, texturedimage, texturedimage);
end

    

texturedimage = double(rgb2gray(texturedimage))/255;
texturedimage1=texturedimage;
texturedimage2=texturedimage;
m=mean(mean(texturedimage,1));


%first part

for j=2:399
    for i=2:399
       
        diff1=[texturedimage2(i,j),texturedimage2(i-1,j-1),texturedimage2(i-1,j),texturedimage2(i-1,j+1),...
            texturedimage2(i,j-1),texturedimage2(i,j+1),texturedimage2(i+1,j-1),texturedimage2(i+1,j),texturedimage2(i+1,j+1)];
        md=mean(diff1);
        MLDO=md;
        M=a*m+b*md;
        
        if MLDO>=M;
            texturedimage1(i,j)=1;
            texturedimage1(i-1,j-1)=1;
            texturedimage1(i-1,j)=1;
            texturedimage1(i-1,j+1)=1;
            texturedimage1(i,j-1)=1;
            texturedimage1(i,j+1)=1;
            texturedimage1(i+1,j-1)=1;
            texturedimage1(i+1,j)=1;
            texturedimage1(i+1,j+1)=1;
        else
           
            texturedimage1(i,j)=0;
            texturedimage1(i-1,j-1)=0;
            texturedimage1(i-1,j)=0;
            texturedimage1(i-1,j+1)=0;
            texturedimage1(i,j-1)=0;
            texturedimage1(i,j+1)=0;
            texturedimage1(i+1,j-1)=0;
            texturedimage1(i+1,j)=0;
            texturedimage1(i+1,j+1)=0;
            
         
        end
     
              

    end
end


