function [ Score ] = doubleimagecompare( i,j )
%This function is used to find the euclidean distance between 400x400 double images which are outputs from Texture based Sign and Magnitude operators    
    V=abs(i-j);
    Score=mean(mean(V));

end
