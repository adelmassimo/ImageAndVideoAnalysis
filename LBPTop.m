path_normalized = strcat(path_person, '/Normalized');
frame_names = dir(strcat(path_normalized,'/f*.png'));
new_folder = '/Planes';
mkdir(path_normalized, new_folder); 
new_path = strcat(strcat(path_normalized, new_folder), '/');
iteration = 1; %per distinguere il primo frame, che sar? sempre quello centrale.

central_frame_x = x_window/2;
central_frame_y = y_window/2;
central_frame = imread(strcat(path_normalized, '/centralFrame.png'));

%estrazione piani relativi ai frame di una persona
XTPlanes = uint16(ones(max(size(central_frame(:,1))), length(frame_names)));
YTPlanes = uint16(ones(length(frame_names), max(size(central_frame(1,:)))));

for frame_name = frame_names'
    
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    frame = imread(path_to_frame);
    
    XTPlanes(:,iteration) = frame(:, floor(central_frame_y));
    YTPlanes(iteration,:) = frame(floor(central_frame_x), :);

    iteration = iteration + 1;
    
end

imwrite(XTPlanes, strcat(new_path, 'XTPlane.png'));
imwrite(YTPlanes, strcat(new_path, 'YTPlane.png'));
imwrite(imread(strcat(path_normalized,'/centralFrame.png')), strcat(new_path, 'XYPlane.png'));