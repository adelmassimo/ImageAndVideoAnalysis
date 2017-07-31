tot = 0;
for i = 1:480
    for j = 1:640
        for k = 1:frame1(i,j)/1000
            tot = tot + k;
            X(tot, :) = [i,j];
        end
    end
end
hist3(X, [480 640])
toc