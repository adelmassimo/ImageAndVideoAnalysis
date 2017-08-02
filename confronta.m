
for k = 1:1    
    k = 3;
    if(k < 10)
        pathFolder=strcat('img/g00',num2str(k),'/person*');
    else
        pathFolder=strcat('img/g0',num2str(k),'/person*');
    end
    
    persons = dir(pathFolder)';
    num_persons = max(size((persons)));
    iteration = 1;
    %scorro la prima metà delle persone (tanto poi sono i soliti che
    %tornano indietro)
    for i = 1:num_persons/2
        best_score = inf; best = 0;
        person = persons(i);
        path = strcat(person.folder,'/', person.name,'/Normalized/Planes/');
        
        XYP = imread(strcat(path, 'XYPlane.png'));
        XTP = imread(strcat(path, 'XTPlane.png'));
        YTP = imread(strcat(path, 'YTPlane.png'));
        
        lbpXY = extractLBPFeatures(XYP,'Upright',true, 'NumNeighbors', 8, 'Radius', 1);
        lbpXT = extractLBPFeatures(XTP,'Upright',true, 'NumNeighbors', 8, 'Radius', 1);
        lbpYT = extractLBPFeatures(YTP,'Upright',true, 'NumNeighbors', 8, 'Radius', 1);

        for j = num_persons/2+1:num_persons

            person = persons(j);
            path = strcat(person.folder,'/', person.name,'/Normalized/Planes/');
            XYP2 = imread(strcat(path, 'XYPlane.png'));
            XTP2 = imread(strcat(path, 'XTPlane.png'));
            YTP2 = imread(strcat(path, 'YTPlane.png'));
            lbpXY2 = extractLBPFeatures(XYP2,'Upright',true, 'NumNeighbors', 8, 'Radius', 1);
            lbpXT2 = extractLBPFeatures(XTP2,'Upright',true, 'NumNeighbors', 8, 'Radius', 1);
            lbpYT2 = extractLBPFeatures(YTP2,'Upright',true, 'NumNeighbors', 8, 'Radius', 1);

            w1 = 15; w2 = 10; w3 = 1;
            meanD = mean(w1*(lbpXY-lbpXY2).^2 + w2*(lbpXT-lbpXT2).^2 + w3*(lbpYT-lbpYT2).^2);
            if(meanD < best_score)
                best = j;
                best_score = meanD;
            end
        end
        disp( strcat(num2str(i), ' con ', num2str(best)) )
    end
    
end