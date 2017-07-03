frame = (imread('../img/g023/a.png'));
c_frame = (imread('../img/g023/c.png'));
%%denoise: azzero il rumore cos? che non possa essere il massimo
frame = frame + uint16(frame == 0)*2^16-1;
c_frame = c_frame + uint16(c_frame == 0)*2^16-1;

%calcolo la costante di normalizzazione
c_max = double(min(c_frame(:)))
maxx = double(min(frame(:)))
C = maxx/c_max

%Guardo un po' cosa ho fatto
n_frame = frame/C;

imshow((n_frame) )
waitforbuttonpress
imshow((frame) )

if(c_max == min(n_frame(:)))
    disp('torna dio cancaro');
end