for i = 1:1    

    if(i < 10)
        pathFolder=strcat('../img/g00',num2str(i),'/person*');
    else
        pathFolder=strcat('../img/g0',num2str(i),'/person*');
    end
    
    persons = dir(pathFolder)';
    num_persons = max(size((persons)));
    iteration = 1;
    %scorro la prima met? delle persone (tanto poi sono i soliti che
    %tornano indietro)
        for i = 1:num_persons/2
            best_score = inf; best = 0;
            person = persons(i);
            path = strcat(person.folder,'/', person.name,'/Normalized/Planes/');
            XYP = imread(strcat(path, 'XYPlane.png'));
            XTP = imread(strcat(path, 'XTPlane.png'));
            YTP = imread(strcat(path, 'YTPlane.png'));
            lbpXY = extractLBPFeatures(XYP,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
            lbpXT = extractLBPFeatures(XTP,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
            lbpYT = extractLBPFeatures(YTP,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
                
            for j = num_persons/2+1:num_persons
                person = persons(j);
                path = strcat(person.folder,'/', person.name,'/Normalized/Planes/');
                XYP2 = imread(strcat(path, 'XYPlane.png'));
                XTP2 = imread(strcat(path, 'XTPlane.png'));
                YTP2 = imread(strcat(path, 'YTPlane.png'));
                lbpXY2 = extractLBPFeatures(XYP2,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
                lbpXT2 = extractLBPFeatures(XTP2,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
                lbpYT2 = extractLBPFeatures(YTP2,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
                
                %stampo
                
                %subplot(3,2,1)
                %imshow(XYP);
                %subplot(3,2,2)
                %imshow(XYP2);
                
                %subplot(3,2,3)
                %imshow(XTP);
                %subplot(3,2,4)
                %imshow(XTP2);
                
                %subplot(3,2,5)
                %imshow(YTP);
                %subplot(3,2,6)
                %imshow(YTP2);
                w1 = 10; w2 = 1; w3 = 1;
                meanD = mean(w1*(lbpXY-lbpXY2).^2 + w2*(lbpXT-lbpXT2).^2 + w3*(lbpYT-lbpYT2).^2);
                if(meanD < best_score)
                    best = j;
                    best_score = meanD;
                end
            end
            
            disp( strcat(num2str(i), ' con ', num2str(best)) )
        end
    
end