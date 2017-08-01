frame1 = imread('../img/g001/person3/Normalized/centralFrame.png');
frame2 = imread('../img/g001/person7/Normalized/centralFrame.png');
frame3 = imread('../img/g001/person5/Normalized/centralFrame.png');
figure
subplot(1,3,1)
title('model')
imshow(frame1);
subplot(1,3,2)
title('correct')
imshow(frame2);
subplot(1,3,3)
title('wrong')
imshow(frame2);
waitforbuttonpress
figure
lbp1 = extractLBPFeatures(frame1,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
lbp2 = extractLBPFeatures(frame2,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);
lbp3 = extractLBPFeatures(frame3,'Upright',false, 'NumNeighbors', 16, 'Radius', 4);

vs1 = (lbp1-lbp2).^2;
vs2 = (lbp1-lbp3).^2;

if(mean(vs1)-mean(vs2)) < 0
    disp 'ok';
else
    disp 'male';
end


bar([vs1; vs2]','grouped')
legend('ok','no')
