path = '../img/g001/person1';
frame_names = dir(strcat(path,'/*rame*.png'));
new_folder = '/Normalized';
mkdir(path, new_folder); 
new_path = strcat(strcat(path, new_folder), '/');
iteration = 0; %per distinguere il primo frame, che sar? semopre quello centrale.
centroids_x = [];
centroids_y = [];

for frame_name = frame_names'
    %carico frame
    path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
    frame = imread(path_to_frame); 
    
    %ricavo la persona dal background e la filtro in modo da avere
    %una sagoma bianca del soggetto.
    person = imsubtract(bg_frame,frame);
    filtered_person = (person > 2500);
    filtered_person = medfilt2(filtered_person, [15 15]);
    
    %essendoci del rumore, a volte avremo alcune aree bianche che
    %potrebbero dare problemi nel calcolo del rettangolo massimo che
    %vogliamo usare. Allora, calcolo le regioni connesse dell'immagine, per
    %ogni regione calcolo l'area e la metto in un vettore. Tendenzialmente
    %mi aspetto che l'area maggiore sia quella della persona: quindi,
    %calcolo l'indice della regione con area massima, e poich? la regione
    %dell'uomo sar? sconnessa da quella dei rumori eventuali, l'indice
    %calcolato corrispender? al numero utilizzato per identificare la
    %regione del soggetto mediante funzione bwlabel.
    %quindi creo la nuova immagine senza rumore (righe 33, 34).
    
    connected_region = bwlabel(filtered_person);
    areas = regionprops(connected_region, 'Area');
    areas_vector = [areas(:).Area];
    [max_area, max_index] = max(areas_vector);
    
    [rows,cols,found] = find(connected_region == max_index);
    
    % non uso connectedregion perch? anche se ? quella che voglio, magari
    % era la regione contrassegnata da un numero diverso da 1, ma io in bw
    % voglio solo 1 e 0.
    
    bw = zeros(size(filtered_person));
    bw(rows,cols) = filtered_person(rows, cols);
    
    
    if mod(iteration,5) == 1 %ciolo ho messo ==1 cos? il central frame non me lo caga.
        [L, Ne] = bwlabel(bw,8);
        
        % Measure properties of image regions
        
        % Calculate bounding box for connected components
        
        propied = regionprops(L,'BoundingBox');
        hold on
        
        % Plot Bounding Box 
        for n = 1:size(propied,1)%da sistemare qui e siamo felici ciolo
            rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
            s = regionprops(bw,'centroid');
            % Concatenate structure array containing centroids into a single matrix
            centroids_x = cat(1, centroids_x, s.Centroid(1));
            centroids_y = cat(1, centroids_y, s.Centroid(2));
        end
    end
    
    x_min = min(cols);
    x_max = max(cols);

    y_min = min(rows);
    y_max = max(rows);

    new_frame = frame(y_min:y_max, x_min:x_max);
    
    if iteration == 0
        frame_id = 'centralFrame.png';
        imwrite( new_frame, strcat(new_path, frame_id));
        [i,j,central_min] = find(new_frame);
        central_min = min(central_min);
        iteration = iteration + 1;
    else
        [i,j,frame_min] = find(new_frame);
        frame_min = min(frame_min);
        N = double(central_min)/double(frame_min);
        new_frame = N*new_frame;
        frame_id = strcat('Frame', num2str(iteration), '.png');
        imwrite(new_frame, strcat(new_path, frame_id));
        iteration = iteration + 1;
    end
end
hold off;
plot(centroids_x, centroids_y)
hold on;
plot(centroids_x, centroids_y, 'x')