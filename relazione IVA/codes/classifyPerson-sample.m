mymatrix = zeros(22,2);
for video_num = 1:22
    
    path=strcat('../img/g0',num2str(video_num));
    
    frame_names = dir(strcat(path,'/*.png')); 
    
    bg_frame = imread( strcat(path,'/frame00000.png') ); 

    raw_bg_mask = bg_frame < mean(mean(bg_frame));
    bg_mask = raw_bg_mask(125:380, 35:625);
    [interruption, person_in_scene, person_count] = [0, 0, 0];
    
    for frame_name = frame_names'

        frame = imread(path_to_frame);
        
        raw_mask = frame < mean(mean(bg_frame));
        mask = raw_mask(125:380, 35:625);
        
        if sum(sum(mask)) > 2900
            if ~person_in_scene
                interruption = 0;
                person_in_scene = 1;
                person_count = person_count + 1;
                
                person_folder = strcat('/person', num2str(person_count));
                mkdir(path, person_folder);
            end
        elseif person_in_scene
            interruption = interruption + 1;
        end
        if interruption > 1
            interruption = 0;
            person_in_scene = 0;
        end
        if person_in_scene
           imwrite( frame, strcat(path, person_folder, '/', frame_name.name) );
        end
        
    end
end