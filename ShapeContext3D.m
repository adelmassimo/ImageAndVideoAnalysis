%% step 1 - Calcolo bordo
tic
frame = 'img/g001/person1/Normalized/Frame1.png';
frame = imread(frame);

edge_points = edge(frame, 'Canny');

[xp, yp, valp] = find(edge_points);


%% step 2 - Calcolo istogramma SENZA CICLI (molto buono)

X = repmat(xp, 1, length(xp));
Y = repmat(yp, 1, length(xp));

%SENZA CICLI (molto buono)

D = sqrt((X - X').^2 + (Y - Y').^2);
mean_distance = mean(mean(D));

D = D./mean_distance;

treshold = 0.125;

qD = zeros(length(xp),length(xp));
 
while sum(sum(D < treshold/2))/(length(xp)^2) ~= 1 %il /2 ce l'ho messo perchè così mi entra anche quando tutti i numeri sono < dell'ultima soglia

    mask = D < treshold;
    
    qD = qD + mask;
    
    treshold = treshold*2;
end

logBins = max(max(qD));

%Ora si deve calcolare l'angolo. N.B le ascisse sono rappresentate dalle
%righe!!!

Angle = atand((X - X')./(Y - Y'));

% aggiungo 180 gradi dove la differenza delle ascisse è minore di 0

addPi = ((Y - Y') < 0);
addPi = 180*addPi;
Angle = Angle + addPi;

% a questo punto ho tutti angoli maggiori di 0, esclusi quelli nel quarto
% quadrante, a cui devo aggiungere 360.

add2Pi = (Angle < 0);
add2Pi = 360*add2Pi;
Angle = Angle + add2Pi;

Angle = Angle*(2*pi)/360;

for i = 1 : length(xp)
    Angle(i,i) = 0;
end

%N.B i punti tra loro simmetrici sono tale che il modulo della differenza
%faccia 3.14 --> pi.

thetaBins = 6;
qAngle = 1 + floor(Angle/(2*pi/thetaBins));

for i = 1 : length(xp)
    points(i).row_index = xp(i);
    points(i).col_index = yp(i);
    points(i).shape_context = shapeContext(qD(i,:),qAngle(i,:),  logBins,thetaBins);
    tmpRow = points(i).shape_context';
    tmpRow = tmpRow(:);
    histMatrix(i,:) = tmpRow';
end
%% step 3 - Calcolo matrice dei costi

% si mette questo, perchè in corrispondenza degli 0
% ovuneque si guarda, l'immagine è sempre bianca
% Bisogna vedere se i valori non uguali a zero vanno
% bene, ma chissà... Questo comunque si fa anche perchè
% per calcolare la matrice di costo, se a denominatore e
% a numeratore ho 0, si ottiene NaN; in questo modo
% invece male che vada si ottiene Inf, cioè per due
% punti il costo è cosi alto che probabilmente quei due
% punti sono molto lontani.

%P.S. in origine era 255 - hist..
                   
%a questo punto l'unico problema sarebbe stato che se facessi 255 -
%qualcosa, c'era il rischio di avere valori negativi che mi causavano un
%Inf, che a noi ci avrebbe dato noia.. Allora facciamo il Max - hist e non
%compare mai

%DUBBIO: è giusto fare questa sottrazione scegliendo il max del max? oppure
%sarebbe meglio farla per ogni riga usando il max di quella riga?? boh.

maximum = max(max(histMatrix));
histMatrix = maximum - histMatrix;
%Sono riuscito a eliminare il ciclo su k e su j, ma non su i per calcolare
%questa matrice

for i = 1 : length(xp)
    CostMatrix(i, :) = rowCostMatrix(i, histMatrix);
end


%Altro dubbio. Perchè creare una matrice di costo su pounti di una stessa
%immagine quando poidovremmo confrontare???
toc
