tic
for video_num = 19 : 22
    if(video_num < 10)
        path=strcat('img/g00',num2str(video_num));
    else
        path=strcat('img/g0',num2str(video_num));
    end
    
    frame_names = dir(strcat(path,'/*.png')); %salvo qui tutti i frame
    
    bg_frame = imread( strcat(path,'/frame00000.png') ); %assegno frame di backGround
    raw_bg_mask = bg_frame < mean(mean(bg_frame));
    bg_mask = raw_bg_mask(125:380, 35:625);
    interruption = 0;
    person_in_scene = 0;
    person_count = 0;
    
    for frame_name = frame_names'
        
        %concateno 2 stringa: 1. Nome cartella del frame, 2. Nome frame
        path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
        
        %lo leggo per avere l'immagine vera e propria
        frame = imread(path_to_frame);
        
        raw_mask = frame < mean(mean(bg_frame));
        mask = raw_mask(125:380, 35:625);
        
        if sum(sum(mask)) > 2900
            if ~person_in_scene
                interruption = 0;
                person_in_scene = 1;
                %waitforbuttonpress
                person_count = person_count + 1;
                %Creo una nuova Cartella
                if person_count < 10
                    person_folder = strcat('/person0', num2str(person_count));
                else
                    person_folder = strcat('/person', num2str(person_count));
                end
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
            %salvo
            imwrite( frame, strcat(path, person_folder, '/', frame_name.name) );
            %imshow(mask)
        end
        %waitforbuttonpress
        
    end
    pathFolder = strcat(path, '/person*');
    persons = dir(pathFolder)';
    if video_num == 7 || video_num == 15
        num_persons = max(size((persons))) - 1;
    else
        num_persons = max(size((persons)));
    end
    
    for person_num = 1 : num_persons
        if person_num < 10
            path_person = strcat(path, '/person0', num2str(person_num));
        else
            path_person = strcat(path, '/person', num2str(person_num));
        end
        centralFrameDetector;
        normalizeCutAndTranslate;
        LBPTop;
    end
end


toc