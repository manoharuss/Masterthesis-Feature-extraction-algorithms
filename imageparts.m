function [ k ] = imageparts( rgbimage,parts )
%This function splits each image into the number of parts the user has
%requested it for
%Takes an rgbimage, a number of segmentations as input

%This function calculates segments blocks column wise.Unlike image256 function which calculates row wise


%Check if input image is a an rgb image or not, if not convert.
if (size(rgbimage,3) == 1)
    rgbimage = cat(3,rgbimage,rgbimage,rgbimage);
end


%Next we calculate the block size for each image.
%Then we go cropping row wise with block size and take the mean rgb values



imagesize = size(rgbimage);

columns=floor(sqrt(parts));
blockLength = round(imagesize(1:2)/columns);

columns=columns-1;
k=[];
%For loop here for all blocks
for j=0:columns
    for i=0:columns
        temp=imcrop(rgbimage,[j*(blockLength(1,2)) (i)*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
        tempk=mean( reshape( temp, [], 3 ), 1 );
        k=[k;tempk];
        
    end
end


k=transpose(k);

