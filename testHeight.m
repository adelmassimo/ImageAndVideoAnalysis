results = zeros(22);
for i = 1:10
    if(i < 10)
        pathFolder=strcat('../img/g00',num2str(i),'/person');
    else
        pathFolder=strcat('../img/g0',num2str(i),'/person');
    end
    
    n = length(dir(strcat(pathFolder,'*')));
    
    for j = 1:n/2
        
        frame1 = medfilt2( imread(strcat(pathFolder,int2str(j),'/centralFrame.png')), [10 10]);
        best = inf;
        person = 0;
        for k = n/2+1:n
            path = strcat(pathFolder,int2str(k),'/centralFrame.png');
            frame2 = medfilt2( imread(path), [10 10]);

            l1 = 239; l2 = 10;
            h1 = mean(mean( frame1(240-l1:240+l1, 320-l2:320+l2) ));
            h2 = mean(mean( frame2(240-l1:240+l1, 320-l2:320+l2) ));

            score = abs(h2 - h1);
            if score < best
                best = score;
                person = k;
            end
        end
        
        results(i, 2*j-1) = j;
        results(i, 2*j) = person;
        
    end
end