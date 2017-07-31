% A questo punto io do per scontato di avere nella cartella person-i i suoi
% relativi frame
if(~exist('path', 'var'))
    path = '../img/g002/person3';
    error('manca il dio');
end
bg_frame = imread( strcat(path,'/background.png')); %assegno frame di backGround

%al solito, qui ci metto tutti i frame
frame_names = dir(strcat(path,'/*.png'));


best_score = -inf;

for frame_name = frame_names'
%read the frames from path folder    
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name)
    frame = imread(path_to_frame);
    
    %sottraggo al backgroundd il frame --> In questo modo si invertono i
    %colori: a colore scuro corrisponde maggiore profondit?
    diff =  imsubtract(bg_frame,frame);
    
%maybe we want to apply a filter to reduce noise... boh
    %filtered = medfilt2( imcomplement(diff),[10 10]);
    
%set window size
    l1 = 239; l2 = 10;

%can we apply a tolerance... boh?
    %mask = filtered > 2^16-1000;
    %filtered(mask) = 2^16;
    
    %definisco una piccola area di dimensione 70x70 che va 215-275(in
    %larghezza) e 285-355 (in altezza)
    center = medfilt2(diff(240-l1:240+l1, 320-l2:320+l2), [20 20]); 

%sommo i pixel centrali
    score = sum(center(:));
%se la somma ? meglio del vecchio best allora ho un nuovo campione..
    if( score > best_score )
        central_frame = frame;%.. e lo salvo in central frame
        best_score = score;
        %imshow(imcomplement(center))
    end
    %imshow(center)
    %imshowpair(diff, center, 'montage')  
end

imwrite( central_frame, strcat(path, '/centralFrame.png'));%a questo punto salvo il frame(originale e non 
%in negativo) che aveva la somma di pixel maggiore nella finestra (che per?
%usava il frame in negativo: ? per questo che uso il maggiore nel controllo
%dell'if
