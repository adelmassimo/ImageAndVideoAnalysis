clear couple;
w1 = 10; w2 = 5; w3 = 1;
for k = 1:1    
    k=3;
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
        
%         lbpXY1 = extractLBPFeatures(XYP,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
%         lbpXT1 = extractLBPFeatures(XTP,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
%         lbpYT1 = extractLBPFeatures(YTP,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
        lbpXY1 = extractLBPFeatures(XYP,'Upright', true, 'NumNeighbors', 16, 'Radius', 4);
        lbpXT1 = extractLBPFeatures(XTP,'Upright', true, 'NumNeighbors', 16, 'Radius', 4);
        lbpYT1 = extractLBPFeatures(YTP,'Upright', true, 'NumNeighbors', 16, 'Radius', 4);
        lbp1 = [lbpXY1, lbpXT1, lbpYT1];
        
        for j = num_persons/2+1:num_persons

            person = persons(j);
            path = strcat(person.folder,'/', person.name,'/Normalized/Planes/');
            XYP2 = fliplr(imread(strcat(path, 'XYPlane.png')));
            XTP2 = fliplr(imread(strcat(path, 'XTPlane.png')));
            YTP2 = fliplr(imread(strcat(path, 'YTPlane.png')));
%             lbpXY2 = extractLBPFeatures(XYP2,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
%             lbpXT2 = extractLBPFeatures(XTP2,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
%             lbpYT2 = extractLBPFeatures(YTP2,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
%         
            lbpXY2 = extractLBPFeatures(XYP2,'Upright', true, 'NumNeighbors', 16, 'Radius', 4);
            lbpXT2 = extractLBPFeatures(XTP2,'Upright', true, 'NumNeighbors', 16, 'Radius', 4);
            lbpYT2 = extractLBPFeatures(YTP2,'Upright', true, 'NumNeighbors', 16, 'Radius', 4);
            
            lbp2 = [lbpXY2, lbpXT2, lbpYT2];
      
            lbp = [10*(lbpXY1-lbpXY2).^2, 5*(lbpXT1-lbpXT2).^2, (lbpYT1-lbpYT2).^2];
            
%             figure;
%             bar(lbp);
%             title(strcat(num2str(i), '-', num2str(j)));

            meanD = sum(lbp);
            couple(i,j) = meanD;
            %meanD = sum(w1*(lbpXY1-lbpXY2).^2 + w2*(lbpXT1-lbpXT2).^2 + w3*(lbpYT1-lbpYT2).^2);
            
            if(meanD < best_score)
                best = j;
                best_score = meanD;
            end
        end
        disp( strcat(num2str(i), ' con ', num2str(best)) )
    end
    couple
end