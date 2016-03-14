function result = matrixcompare( i,j )
%This function takes 2 vectors of same length and calculates the euclidean distance between them. We use this function to calculate distances between vectors we obtain using mean RGB values in the mean RGB based comparison operators

    result=sqrt(sum(sum((i-j).^2)));

end

