tic
for video_num = 14 : 18
    if(video_num < 10)
        path=strcat('img/g00',num2str(video_num));
    else
        path=strcat('img/g0',num2str(video_num));
    end
    
    frame_names = dir(strcat(path,'/*.png')); %salvo qui tutti i frame
    
    bg_frame = imread( strcat(path,'/frame00000.png') ); %assegno frame di backGround
    bg_sum = sum(bg_frame(:));%sommo tutti i valori dei pixel di background
    
    bound = bg_sum * 0.99; %indicativamente se rimango sopra bound vuol dire che i colori non sono cambiati
    % Se sto sotto allora c'è più pixel neri (cioè è
    % entrato qualcuno)
    
    
    max_interruption = 15;%Indica il max n. frame consecutivi per cui una persona non è riconosciuta:
    %si utilizza insieme a empty_frames. Infatti a volte capita
    %che la somma dei frame non sta sotto la soglia
    %nonostante la presenza del soggetto,
    person_count = 0;
    same_person = false;
    empty_frames = 1;
    
    %assegna a frame_name un elemento di frame_names alla volta ciclando
    for frame_name = frame_names'
        
        
        %read the frames from path folder
        
        %concateno 2 stringa: 1. Nome cartella del frame, 2. Nome frame
        path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
        
        %lo leggo per avere l'immagine vera e propria
        frame = imread(path_to_frame);
        
        %sommo i pixel
        frame_sum = sum(frame(:));
        
        
        %se ci sono più pixel scuri allora è entrato l'omino
        if(frame_sum < bound)
            
            %Sto esaminando la stessa persona? Se NO allora:
            if(~same_person)
                
                %inizio a classificare una persona per la prima volta
                
                %nuova persona: è la prima volta che la vedo, quindi metto empty_frame a 0
                empty_frames = 0;
                person_count = person_count + 1;
                
                %se ho trovato una persona diversa aggiungo la cartella
                if person_count < 10
                    person_folder = strcat('/person0', num2str(person_count));
                else
                    person_folder = strcat('/person', num2str(person_count));
                end
                mkdir(path, person_folder);
                
                same_person = true;
                person_folder2 = strcat( strcat(path, person_folder), '/');
            end
            
            imwrite( frame, strcat(person_folder2, frame_name.name) );
            
        else
            
            %questo è il caso in cui non si sta sotto la soglia, quindi aumento
            %empty_frames. Inoltre, se una persona l'ho già incontrata, ma non
            %è stato superato max interruption, allora mi aspetto che lei però sia ancora
            %presente in scena, quindi, se è la stessa persona, aggiungo il
            %frame.
            if(empty_frames < max_interruption)
                empty_frames = empty_frames + 1;
                
                if(same_person)
                    imwrite( frame, strcat(person_folder2, frame_name.name) );
                    
                end
                %altrimenti dopo 9 interruzioni, assumo che non ci sia nessauno
                %in scena e arriverà un cristiano
            else
                same_person = false;
            end
        end
    end
     
    pathFolder = strcat(path, '/person*');
    persons = dir(pathFolder)';
    num_persons = max(size((persons)));
    for person_num = 1 : num_persons %-1 solo per video7
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