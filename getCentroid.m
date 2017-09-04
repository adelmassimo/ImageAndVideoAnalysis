function [x, y] = getCentroid(frame)
    padding_t = 135;
    padding_l = 35;
    padding_b = 115;
    padding_r = 15;

    frame_n = medfilt2(imcomplement( frame(padding_t:480-padding_b, padding_l:640-padding_r) ), [20 20]);
    frame_n  = frame_n.*uint16(frame_n < 38000);

    frame_punto = uint16(frame_n == max(max(frame_n)));
    [row, col] = find(frame_punto);

    x = floor(mean(row))+padding_t;
    y = floor(mean(col))+padding_l;
end