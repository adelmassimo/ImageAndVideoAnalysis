minimum = inf;
index = 0;
X = imread('../img/g001/person1/Normalized/trajectory.png');
X = rgb2gray(X);
Y = imread('../img/g001/person2/Normalized/trajectory.png');
Y = rgb2gray(Y);
for i = 1:361
    Y = imrotate(Y, i-1, 'crop');
    Z = imsubtract(X,Y);
    
    if(minimum > sum(Z(:)))
       minimum = sum(Z(:));
       index = i;
    end

end
