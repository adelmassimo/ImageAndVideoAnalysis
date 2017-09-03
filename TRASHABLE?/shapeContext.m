function sc = shapeContext(qDRow, qAngleRow, dBins, angleBins)
    rows = dBins;
    cols = angleBins;
    
    sc = zeros(rows,cols);
    for i = 1 : length(qDRow) 
        sc(qDRow(i),qAngleRow(i)) = sc(qDRow(i),qAngleRow(i)) + 1;
    end
    
    % Per usare imshow subito, si deve normalizzare a 255, altrimenti si
    % possono usare i numeri normali e impostare in imshow l'opzione [0
    % 255].
    % Se si vuole il negativo, basta fare 255 - sc, poi vale lo stesso
    % discorso per la stampa.
    
%     sc = sc/; 
    %sc = 255 - s;% si mette questo, perchè in corrispondenza degli 0
                   % ovuneque si guarda, l'immagine è sempre bianca
                   % Bisogna vedere se i valori non uguali a zero vanno
                   % bene, ma chissà... Questo comunque si fa anche perchè
                   % per calcolare la matrice di costo, se a denominatore e
                   % a numeratore ho 0, si ottiene NaN; in questo modo
                   % invece male che vada si ottiene Inf, cioè per due
                   % punti il costo è cosi alto che probabilmente quei due
                   % punti sono molto lontani.
                   
      %Ragioniamo: viene infinito se gli istogrammi di due bins sono tra
      %loro uguali ma di segno opposto. Una cosa del genere si ha, per come
      %abbiamo calcolato l'istogramma, che se due punti sono vicini h1(k) e
      %h2(k) siano tra loro molto vicini(cioè nella stessa area dell'istogramma
      % mi aspetto che ci sia lo stesso numero di punti, e quindi sarà il numeratore a
      %tendere a 0, mentre la somma sarà un numero maggiore di 0. Viceversa
      %se due punti sono lontani, nella stessa area
end