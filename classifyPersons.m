path = '../img/g001'; %specifico il percorso
frame_names = dir(strcat(path,'/*.png')); %salvo qui tutti i frame

bg_frame = imread( strcat(path,'/frame00000.png') ); %assegno frame di backGround
bg_sum = sum(bg_frame(:));%sommo tutti i valori dei pixel di background

bound = bg_sum * 0.99; %indicativamente se rimango sopra bound vuol dire che i colori non sono cambiati
                       % Se sto sotto allora c'? pi? pixel neri (cio? ?
                       % entrato qualcuno)

                       
max_interruption = 9;%Indica il max n. frame consecutivi per cui una persona non ? riconosciuta:
                     %si utilizza insieme a empty_frames. Infatti a volte capita
                     %che la somma dei frame non sta sotto la soglia
                     %nonostante la presenza del soggetto,
person_count = 0;
same_person = false;
empty_frames = 1;

%assegna a frame_name un elemento di frame_names alla volta ciclando
for frame_name = frame_names' 
    %concateno 2 stringa: 1. Nome cartella del frame, 2. Nome frame
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    
    %lo leggo per avere l'immagine vera e propria
    frame = imread(path_to_frame); 
    
    difference = frame( 
    
    %sommo i pixel
    frame_sum = sum(frame(:));
    
    %se ci sono piu' pixel scuri allora e' entrato l'omino
    if(frame_sum < bound)
        %sono sotto il buoud: azzero i frame consecutivi vuoti accettabili
        empty_frames = 0;
        
        %Sto esaminando la stessa persona? Se NO allora:
        if(~same_person)
            
            %inizio a classificare una persona per la prima volta 
            person_count = person_count + 1;
            
            %se ho trovato una persona diversa aggiungo la cartella
            person_folder = strcat('/person', num2str(person_count));
            mkdir(path, person_folder); 
            
            same_person = true;
            person_folder2 = strcat( strcat(path, person_folder), '/');
        end
        
        imwrite( frame, strcat(person_folder2, frame_name.name) );
        
    else
        %caso in cui non si sta sotto la soglia, quindi aumento
        %empty_frames. Inoltre, se una persona l'ho gi? incontrata, ma non
        %? stato superato max interruption, allora mi aspetto che lei per? sia ancora 
        %presente in scena, quindi, se ? la stessa persona, aggiungo il
        %frame.
        if(empty_frames < max_interruption)     
            empty_frames = empty_frames + 1;
       
            if(same_person)
                imwrite( frame, strcat(person_folder2, frame_name.name) );
            end
            %altrimenti dopo 9 interruzioni, assumo che non ci sia nessauno
            %in scena e arriver? un cristiano
        else
            same_person = false;
        end
    end
end
