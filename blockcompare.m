function [ selectblock ] = blockcompare( fabric )
%This function uses the outputs from regionofinterest function and select the one with more RGB values in the middle region of the image

imagesize = size(fabric);
blockLength = round(imagesize(1:2)/8);
clear imagesize;

if (size(fabric,3) == 1)
    red_image= cast(cat(3, fabric, zeros(size(fabric)), zeros(size(fabric))), class(fabric));
    green_image = cast(cat(3, zeros(size(fabric)), fabric, zeros(size(fabric))), class(fabric));
    blue_image = cast(cat(3, zeros(size(fabric)), zeros(size(fabric)), fabric), class(fabric));
    fabric=cat(3, red_image(:,:,1), green_image(:,:,2), blue_image(:,:,3));
end
clear red_image green_image blue_image


load regioncoordinates;
nColors = 6;
sample_regions = false([size(fabric,1) size(fabric,2) nColors]);

for count = 1:nColors
    sample_regions(:,:,count) = roipoly(fabric,region_coordinates(:,1,count),...
        region_coordinates(:,2,count));
end

lab_fabric = rgb2lab(fabric);
a = lab_fabric(:,:,2);
b = lab_fabric(:,:,3);
color_markers = zeros([nColors, 2]);

for count = 1:nColors
    color_markers(count,1) = mean2(a(sample_regions(:,:,count)));
    color_markers(count,2) = mean2(b(sample_regions(:,:,count)));
end
color_labels = 0:nColors-1;


for count = 1:nColors
    distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
        (b - color_markers(count,2)).^2 ).^0.5;
end

[~, label] = min(distance,[],3);
label = color_labels(label);
clear distance;
rgb_label = repmat(label,[1 1 3]);
segmented_images = zeros([size(fabric), nColors],'uint8');

for count = 1:nColors
    color = fabric;
    color(rgb_label ~= color_labels(count)) = 0;
    segmented_images(:,:,:,count) = color;
end

a1=segmented_images(:,:,:,1);
a2=segmented_images(:,:,:,2);
a3=segmented_images(:,:,:,3);
a4=segmented_images(:,:,:,4);
a5=segmented_images(:,:,:,5);
a6=segmented_images(:,:,:,6);










%[a1,a2,a3,a4,a5,a6]=regionofinterest(x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REGION 1 a%%%%%%%%%%%
k1=zeros(9,3);
% for the 3rd row
for i=3:5
    temp=imcrop(a1,[i*(blockLength(1,2)) 2*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k1=[k1;tempk];
end

%for 4th row
for i=3:5
    temp=imcrop(a1,[i*(blockLength(1,2)) 3*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k1=[k1;tempk];
end
%for 5th row
for i=3:5
    temp=imcrop(a1,[i*(blockLength(1,2)) 4*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k1=[k1;tempk];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REGION 2 b %%%%%%%%%%%%%
k2=zeros(9,3);
% for the 3rd row
for i=3:5
    temp=imcrop(a2,[i*(blockLength(1,2)) 2*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k2=[k2;tempk];
end
%for 4th row
for i=3:5
    temp=imcrop(a2,[i*(blockLength(1,2)) 3*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k2=[k2;tempk];
end
%for 5th row
for i=3:5
    temp=imcrop(a2,[i*(blockLength(1,2)) 4*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k2=[k2;tempk];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REGION 3 c %%%%%%%%%%555
k3=zeros(9,3);
% for the 3rd row
for i=3:5
    temp=imcrop(a3,[i*(blockLength(1,2)) 2*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k3=[k3;tempk];
end
%for 4th row
for i=3:5
    temp=imcrop(a3,[i*(blockLength(1,2)) 3*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k3=[k3;tempk];
end
%for 5th row
for i=3:5
    temp=imcrop(a3,[i*(blockLength(1,2)) 4*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k3=[k3;tempk];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REGION 4 d %%%%%%%%%%555
k4=zeros(9,3);
% for the 3rd row
for i=3:5
    temp=imcrop(a4,[i*(blockLength(1,2)) 2*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k4=[k4;tempk];
end
%for 4th row
for i=3:5
    temp=imcrop(a4,[i*(blockLength(1,2)) 3*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k4=[k4;tempk];
end
%for 5th row
for i=3:5
    temp=imcrop(a4,[i*(blockLength(1,2)) 4*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k4=[k4;tempk];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REGION 5 e %%%%%%%%%%555
k5=zeros(9,3);
% for the 3rd row
for i=3:5
    temp=imcrop(a5,[i*(blockLength(1,2)) 2*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k5=[k5;tempk];
end
%for 4th row
for i=3:5
    temp=imcrop(a5,[i*(blockLength(1,2)) 3*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k5=[k5;tempk];
end
%for 5th row
for i=3:5
    temp=imcrop(a5,[i*(blockLength(1,2)) 4*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k5=[k5;tempk];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REGION 6 f %%%%%%%%%%555
k6=zeros(9,3);
% for the 3rd row
for i=3:5
    temp=imcrop(a6,[i*(blockLength(1,2)) 2*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k6=[k6;tempk];
end
%for 4th row
for i=3:5
    temp=imcrop(a6,[i*(blockLength(1,2)) 3*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k6=[k6;tempk];
end
%for 5th row
for i=3:5
    temp=imcrop(a6,[i*(blockLength(1,2)) 4*(blockLength(1,1)) blockLength(1,2) blockLength(1,1)]);
    tempk=mean( reshape( temp, [], 3 ), 1 );
    k6=[k6;tempk];
end




clear i temp tempk blockLength;


k1=sum(sum(k1));
k2=sum(sum(k2));
k3=sum(sum(k3));
k4=sum(sum(k4));
k5=sum(sum(k5));
k6=sum(sum(k6));

maxman = max([k1(:), k2(:), k3(:), k4(:), k5(:), k6(:)]);

if maxman==k1
    
    selectblock=a1;
end

if maxman==k2
    
    selectblock=a2;
end

if maxman==k3
    
    selectblock=a3;
end

if maxman==k4
    
    selectblock=a4;
end
if maxman==k5
    
    selectblock=a5;
end

if maxman==k6
    
    selectblock=a6;
end


