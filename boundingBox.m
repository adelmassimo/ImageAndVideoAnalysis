path = '../img/g001';

bg_frame = imread( strcat(path,'/frame00000.png') );

frame_names = dir(strcat(path,'/person2/*.png'));

i = 0;
for frame_name = frame_names' 
    
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    frame = imread(path_to_frame);
    
    if mod(i,5)==0
        %ricavo la persona dal background e la filtro in modo da avere
        %una sagoma bianca del soggetto.
        person = imsubtract(bg_frame,frame);
        filtered_person = (person > 2500);
        filtered_person = medfilt2(filtered_person, [15 15]);
    
        connected_region = bwlabel(filtered_person);
        areas = regionprops(connected_region, 'Area');
        areas_vector = [areas(:).Area];
        [max_area, max_index] = max(areas_vector);
    
        [rows,cols,found] = find(connected_region == max_index);
    
        bw = zeros(size(filtered_person));
        bw(rows,cols) = filtered_person(rows, cols);
        
        % Commentando queste 2 cose ho la figura con tutti i centroidi
        % calcolati!
        %figure()
        %imshow(bw);
        [L, Ne]=bwlabel(bw,8);
        %% Measure properties of image regions
        propied=regionprops(L,'BoundingBox');
        hold on
        %% Plot Bounding Box
        for n=1:size(propied,1)
            rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
            s = regionprops(bw,'centroid');
            centroids = cat(1,s.Centroid);
            hold on
            plot(centroids(:,1),centroids(:,2), 'b*')
            hold off
        end
        
    end
    i = i + 1;

end
