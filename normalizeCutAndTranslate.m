frame_names = dir(strcat(path_person,'/*.png'));
new_folder = '/Normalized';
mkdir(path_person, new_folder);
new_path = strcat(strcat(path_person, new_folder), '/');
iteration = 0; %per distinguere il primo frame, che sar? semopre quello centrale.
centroids_x = []; % forse non ? necessario salvare qui i centroidi!! Anzi ne sono quasi sicuro
centroids_y = [];
finish = false;
for frame_name = frame_names'
    if finish == false
        
        %carico frame
        path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
        frame = imread(path_to_frame);
        
        %ricavo la persona dal background e la filtro in modo da avere
        %una sagoma bianca del soggetto.
        person = imsubtract(bg_frame,frame);
        filtered_person = (person > 13000); %pi? ? alto e pi? sono precisi i centroidi, ma si vengono a creare vari problemi
        filtered_person = medfilt2(filtered_person, [10 10]);
        
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
        
        
        s = regionprops(bw,'centroid');
        centroids_x = cat(1, centroids_x, s.Centroid(1));
        centroids_y = cat(1, centroids_y, s.Centroid(2));
        
        
        
        if iteration == 0
            x_min = min(cols);
            x_max = max(cols);
            
            x_window = (x_max - x_min) + 90;
            
            y_min = min(rows);
            y_max = max(rows);
            
            y_window = (y_max - y_min) + 60;
            
            new_frame = frame(floor(centroids_y(length(centroids_y)) - y_window/2) : ...
                floor(centroids_y(length(centroids_y)) + y_window/2), ...
                floor(centroids_x(length(centroids_y)) - x_window/2) : ...
                floor(centroids_x(length(centroids_y)) + x_window/2));
            frame_id = 'centralFrame.png';
            
            imwrite( new_frame, strcat(new_path, frame_id));
            [i,j,central_min] = find(new_frame);
            central_min = min(central_min);
            iteration = iteration + 1;
            
            %per traslazione
            %moving_points = [centroids_x(length(centroids_x)),centroids_y(length(centroids_x)); 85, 384; 576, 362];
            
            %con questo controllo, le persone alte e che fanno passi pi? lunghi
            %vedranno salvato un minor numero di frame MI SA CHE HO
            %SBAGLIATO: credo basti mettere il centroide maggiore.
        elseif  floor(centroids_x(length(centroids_y)) - x_window/2) > x_window/2 && ...
                floor(centroids_x(length(centroids_y)) + x_window/2) <= (max(size(frame)) - x_window/2) ...
                %&& floor(centroids_y(length(centroids_y)) - y_window/2) > y_window/2 ...
                %&& floor(centroids_y(length(centroids_y)) + y_window/2) <= (min(size(frame)) - y_window/2) ...
            
            new_frame = frame(floor(centroids_y(length(centroids_y)) - y_window/2) : ...
                floor(centroids_y(length(centroids_y)) + y_window/2), ...
                floor(centroids_x(length(centroids_y)) - x_window/2) : ...
                floor(centroids_x(length(centroids_y)) + x_window/2));
            
            
            [i,j,frame_min] = find(new_frame);
            frame_min = min(frame_min);
            if frame_min == 0
                frame_min = 1;
            end
            N = double(central_min)/double(frame_min);
            new_frame = N*new_frame;
            
            frame_id = strcat('Frame', num2str(iteration), '.png');
            imwrite(new_frame, strcat(new_path, frame_id));
            
            iteration = iteration + 1;
        elseif floor(centroids_x(length(centroids_y)) + x_window/2) > (max(size(frame)) - x_window/2)...
                && person_num <= num_persons/2
            finish = true;
        elseif floor(centroids_x(length(centroids_y)) - x_window/2) <= x_window/2 ...
                && person_num > num_persons/2
            finish = true;
        end
    end
end