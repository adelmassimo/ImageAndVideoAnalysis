
for video_num = 1:10
    
    if(video_num < 10)
        path=strcat('../img/g001/person0',num2str(video_num));
    else
        path=strcat('../img/g001/person',num2str(video_num));
    end
    frame_names = dir(strcat(path,'/*.png')); %salvo qui tutti i frame
    
    %bg_frame = imread( strcat(path,'/frame00000.png') ); %assegno frame di backGround

    for frame_name = frame_names'

        %concateno 2 stringa: 1. Nome cartella del frame, 2. Nome frame
        path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
        
        %lo leggo per avere l'immagine vera e propria
        frame = imread(path_to_frame);
        
        [x, y] = getCentroid(frame);
        
        imshow(frame)
        hold on
        scatter(y, x, 'MarkerFaceColor',[0 .7 .7]);
        
        waitforbuttonpress
    end
    
end