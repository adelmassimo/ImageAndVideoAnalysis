clear all;
w1 = 1; w2 = 10; w3 = 10;
myCouple1 = [];
myCouple2 = [];
k = 1;
upright = false;
nn = 32;
r = 4;

for video_num = 1:22
    if(video_num < 10)
        pathFolder=strcat('../dataset/g00',num2str(video_num),'/p*');
    else
        pathFolder=strcat('../dataset/g0',num2str(video_num),'/p*');
    end
    
    disp(strcat('Video ', num2str(video_num)));
    persons = dir(pathFolder)';
    
    if video_num == 7 || video_num == 15
        num_persons = max(size((persons))) - 1;
    else
        num_persons = max(size((persons)));
    end
    %scorro la prima met? delle persone (tanto poi sono i soliti che
    %tornano indietro)
    for i = 1 : (num_persons)/2
        best_score = inf; best = 0;
        person = persons(i);
        path = strcat(person.folder,'/', person.name,'/');
        
        XYP = imread(strcat(path, 'XYPlane.png'));
        XTP = imread(strcat(path, 'XTPlane.png'));
        YTP = imread(strcat(path, 'YTPlane.png'));
        
        %         lbpXY1 = extractLBPFeatures(XYP,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
        %         lbpXT1 = extractLBPFeatures(XTP,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
        %         lbpYT1 = extractLBPFeatures(YTP,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
        lbpXY1 = extractLBPFeatures(XYP,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
        lbpXT1 = extractLBPFeatures(XTP,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
        lbpYT1 = extractLBPFeatures(YTP,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
        lbp1 = [lbpXY1, lbpXT1, lbpYT1];
        
        for j = (num_persons)/2 + 1 : num_persons
            
            person = persons(j);
            path = strcat(person.folder,'/', person.name,'/');
            XYP2 = fliplr(imread(strcat(path, 'XYPlane.png')));
            XTP2 = fliplr(imread(strcat(path, 'XTPlane.png')));
            YTP2 = fliplr(imread(strcat(path, 'YTPlane.png')));
            %             lbpXY2 = extractLBPFeatures(XYP2,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
            %             lbpXT2 = extractLBPFeatures(XTP2,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
            %             lbpYT2 = extractLBPFeatures(YTP2,'Upright', false, 'NumNeighbors', 16, 'Radius', 4);
            %
            lbpXY2 = extractLBPFeatures(XYP2,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
            lbpXT2 = extractLBPFeatures(XTP2,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
            lbpYT2 = extractLBPFeatures(YTP2,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
            
            lbp2 = [lbpXY2, lbpXT2, lbpYT2];
            %usare distanza chiquadro
    %   The chi-squared distance between two vectors is defined as:
    %    d(x,y) = sum( (xi-yi)^2 / (xi+yi) ) / 2;
    %   The chi-squared distance is useful when comparing histograms.
            %lbp = [(lbpXY1-lbpXY2).^2, (lbpXT1-lbpXT2).^2, (lbpYT1-lbpYT2).^2];
            lbp = (lbp1-lbp2).^2/(lbp1+lbp2);
            %             figure;
            %             bar(lbp);
            %             title(strcat(num2str(i), '-', num2str(j)));
            
            meanD = sum(lbp)/2;
            couple(i,j) = meanD;
            meanD = sum(w1*(lbpXY1-lbpXY2).^2 + w2*(lbpXT1-lbpXT2).^2 + w3*(lbpYT1-lbpYT2).^2);
            
            if(meanD < best_score)
                best = j;
                best_score = meanD;
            end
        end
        disp(strcat(strcat(num2str(i), ' - '), num2str(best)));
        myCouple1(k) = i;
        myCouple2(k) = best;
        k = k + 1;
    end
    disp(' ');
end
%     myCouple1 = cat(2,myCouple1,myCouple1tmp);
%     myCouple2 = cat(2,myCouple2,myCouple2tmp);


myCouple1 = myCouple1';
myCouple2 = myCouple2';

score;