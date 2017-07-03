path = '../img/g001/person1/Normalized';
outPath = '../models'
frame_names = dir(strcat(path,'/Frame*.png'));
total_frames = max(size(frame_names));
M = 256; N = 256;
background = (uint16( zeros(M)));
for frame_name = frame_names'
    %carico frame
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    frame = imread(path_to_frame); 
    [m n] = size(frame);
    
    
    background(1:m,1:n) =  background(1:m,1:n) + frame/total_frames;
    imshow(background)

end
