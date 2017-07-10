
path = '../img/g001';

person_folder2 = '';
frame_names = dir(strcat(path,'/*.png')); %salvo qui tutti i frame

bg_frame = imread( strcat(path,'/frame00000.png') ); %assegno frame di backGround
bg_sum = sum(bg_frame(:));%sommo tutti i valori dei pixel di background

bound = bg_sum * 0.99;  
max_interruption = 9;
person_count = 0;
same_person = false;
empty_frames = 1;
min_frames_per_person = 20;

for frame_name = frame_names' 
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    frame = imread(path_to_frame); 
    
    frame_sum = sum(frame(:));
    if(frame_sum < bound)
        empty_frames = 0;
        
        if(~same_person)
            
            person_count = person_count + 1;
            
            person_folder = strcat('/person', num2str(person_count));
            mkdir(path, person_folder); 
            
            same_person = true;
            person_folder2 = strcat( strcat(path, person_folder), '/');
            imwrite( bg_frame, strcat(person_folder2, 'background.png') );
        end
        
        imwrite( frame, strcat(person_folder2, frame_name.name) );
        
    else
        if(empty_frames < max_interruption)     
            empty_frames = empty_frames + 1;
       
            if(same_person)
                imwrite( frame, strcat(person_folder2, frame_name.name) );
            end
        else
            frames_detected = max(size(dir(strcat(person_folder2,'*.png'))));
            if (frames_detected < min_frames_per_person && same_person)
                rmdir(person_folder2, 's');
                person_count = person_count-1;
            end
            same_person = false;
        end
    end
end
