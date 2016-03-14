function [hsvClassification] = hsvclassification(inputimage,hclass,sclass,vclass)
% This function takes an image to be quantized in hsv color space into
% given classes
% The output is a vector indicating the features extracted from hsv
% classification

if size(inputimage, 3) ==1
    inputimage=cat(3, inputimage, inputimage, inputimage);
end

[m, n, ~] = size(inputimage);
inputimage = rgb2hsv(inputimage);

% split image into h, s & v
h = inputimage(:, :, 1);
s = inputimage(:, :, 2);
v = inputimage(:, :, 3);


numberOfLevelsForH = hclass;
numberOfLevelsForS = sclass;
numberOfLevelsForV = vclass;

hsvClassification = zeros(hclass, sclass, vclass);

% Find the maximum.
maxValueForH = max(h(:));
maxValueForS = max(s(:));
maxValueForV = max(v(:));


% create column vector of indexes for later reference
index = zeros(m*n, 3);

% Put all pixels into one of the "numberOfLevels" levels.
count = 1;
for row = 1:size(h, 1)
    for col = 1 : size(h, 2)
        quantizedforH(row, col) = ceil(numberOfLevelsForH * h(row, col)/maxValueForH);
        quantizeforS(row, col) = ceil(numberOfLevelsForS * s(row, col)/maxValueForS);
        quantizedforV(row, col) = ceil(numberOfLevelsForV * v(row, col)/maxValueForV);
        
        % keep indexes where 1 should be put in matrix hsvHist
        index(count, 1) = quantizedforH(row, col);
        index(count, 2) = quantizeforS(row, col);
        index(count, 3) = quantizedforV(row, col);
        count = count+1;
    end
end

% put each value of h,s,v to the matrix
for row = 1:size(index, 1)
    if (index(row, 1) == 0 || index(row, 2) == 0 || index(row, 3) == 0)
        continue;
    end
    hsvClassification(index(row, 1), index(row, 2), index(row, 3)) = ... 
        hsvClassification(index(row, 1), index(row, 2), index(row, 3)) + 1;
end

% normalize hsvHist to unit sum
hsvClassification = hsvClassification(:)';
hsvClassification = hsvClassification/sum(hsvClassification);

% clear variables
clear('row', 'col', 'count', 'numberOfLevelsForH', 'numberOfLevelsForS', ...
    'numberOfLevelsForV', 'maxValueForH', 'maxValueForS', 'maxValueForV', ...
    'index', 'rows', 'cols', 'h', 's', 'v', 'image', 'quantizedValueForH', ...
    'quantizedValueForS', 'quantizedValueForV');



end