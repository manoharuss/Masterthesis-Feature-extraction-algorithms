function [ region1,region2,region3,region4,region5,region6 ] = regionofinterest( fabric )
%This function divided an image into 6 major colours in the image similar to histogram watershed classification each colour represents each section of image so we can get center reigon which is the region of interest or content of an image
if (size(fabric,3) == 1)
    red_image= cast(cat(3, fabric, zeros(size(fabric)), zeros(size(fabric))), class(fabric));
    green_image = cast(cat(3, zeros(size(fabric)), fabric, zeros(size(fabric))), class(fabric));
    blue_image = cast(cat(3, zeros(size(fabric)), zeros(size(fabric)), fabric), class(fabric));
    fabric=cat(3, red_image(:,:,1), green_image(:,:,2), blue_image(:,:,3));
end
clear red_image gree_image blue_image


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

region1=segmented_images(:,:,:,1);
region2=segmented_images(:,:,:,2);
region3=segmented_images(:,:,:,3);
region4=segmented_images(:,:,:,4);
region5=segmented_images(:,:,:,5);
region6=segmented_images(:,:,:,6);
end

