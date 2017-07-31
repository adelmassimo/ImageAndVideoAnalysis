path = 'img/g001/person1/Normalized';
frame_names = dir(strcat(path,'/*.png'));
new_folder = '/Planes';
mkdir(path, new_folder); 
new_path = strcat(strcat(path, new_folder), '/');
iteration = 0; %per distinguere il primo frame, che sarà sempre quello centrale.
central_frame_x = x_window/2;
central_frame_y = y_window/2;

%estrazione piani relativi ai frame di una persona

for frame_name = frame_names'
    
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    frame = imread(path_to_frame);
    
    if iteration == 0
        %piano xy
        frame_id = 'XYPlane.png';
        imwrite(frame, strcat(new_path, frame_id));  
        
        iteration = iteration + 1;
    else
        XTPlanes(iteration, :) = frame(floor(central_frame_y), :);
        YTPlanes(:, iteration) = frame(:, floor(central_frame_x));
        
        iteration = iteration + 1;
    end
end

frame_id = 'XTPlane.png';
imwrite(XTPlanes, strcat(new_path, frame_id));

frame_id = 'YTPlane.png';
imwrite(YTPlanes, strcat(new_path, frame_id));