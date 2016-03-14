function [ BW,BW1,threshold1 ] = imageedgedetect( rgbimage )
%This function takes an rgbimage as an input and converts them into grey images to estimate edges using Matlab inbuit operator for sobel


if size(rgbimage, 3) == 3
    rgbimage=rgb2gray(rgbimage);
end

fudgeFactor = .289;
[BW1, threshold1] = edge(rgbimage, 'sobel');
BW = edge(rgbimage,'sobel', threshold1 * fudgeFactor);
