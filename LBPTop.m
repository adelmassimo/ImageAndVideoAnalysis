path = '../img/g003/person2/Normalized';
frame_names = dir(strcat(path,'/Frame*.png'));
new_folder = '/Planes';
mkdir(path, new_folder); 
new_path = strcat(strcat(path, new_folder), '/');
iteration = 1; %per distinguere il primo frame, che sar? sempre quello centrale.

central_frame_x = x_window/2;
central_frame_y = y_window/2;

%estrazione piani relativi ai frame di una persona
XTPlanes = uint16(ones(max(size(frame(:,1))), length(frame_names)));
YTPlanes = uint16(ones(length(frame_names), max(size(frame(1,:)))));

for frame_name = frame_names'
    
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    frame = imread(path_to_frame);
    
    XTPlanes(:,iteration) = frame(:, floor(central_frame_y));
    YTPlanes(iteration,:) = frame(floor(central_frame_x), :);

    iteration = iteration + 1;
    
end

imwrite(XTPlanes, strcat(new_path, 'XTPlane.png'));
imwrite(YTPlanes, strcat(new_path, 'YTPlane.png'));
imwrite(imread(strcat(path,'/centralFrame.png')), strcat(new_path, 'XYPlane.png'));