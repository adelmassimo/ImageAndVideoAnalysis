couple1 = [1,2,3,4, 1,2,3, 1,2, 1,2,3, 1,2,3,4, 1,2,3,4,5,6,7, 1,2,3,4,5,6, 1,2,3, 1,2, ...
    3,4, 1,2,3,4,5,6, 1,2,3,4,5, 1,2,3,4,5,6,7, 1,2,3,4,5,6, 1,2,3,4,5, 1,2,3,4,5,...
    6, 1,2,3,4, 1,2,3,4,5, 1,2,3, 1,2,3,4,5, 1,2,3,4, 1,2, 1,2,3]';
couple2 = [8,5,7,6, 4,6,5, 4,3, 6,4,5, 6,8,5,7, 10,14,9,12,8,13,11, 11,12,10,8,7,9, ...
    6,4,5, 8,5,7,6, 10,12,9,11,7,8, 9,7,10,6,8, 12,13,10,14,8,11,9, 10,12,8,11,7,...
    9, 9,7,10,6,8, 9,11,8,10,12,7, 8,6,9,5, 9,7,10,6,8, 6,4,5, 8,7,10,6,9, 6,8,5,7,...
    3,4, 5,4,6]';%,5,6,4]';

sum = 0;
for it = 1 : length(couple1)
    if couple2(it) == myCouple2(it)
        sum = sum + 1;
    end
end

successScore = sum/(length(couple1))*100;
errorScore = (length(couple1) - sum)/(length(couple1))*100;

disp(strcat(strcat('Succes Score: ', num2str(successScore)),'%'));