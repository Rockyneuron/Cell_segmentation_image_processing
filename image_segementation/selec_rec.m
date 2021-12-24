function[img_map]=selec_rec(im)


 figure, imagesc(im), colormap gray,axis image
     h_rect = imrect();


% % Rectangle position is given as [xmin, ymin, width, height]
pos_rect = h_rect.getPosition();
% Round off so the coordinates can be used as indices
pos_rect = round(pos_rect);
% Select part of the image
img_map = im(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));
% histograma del ROI
proi=imhist(img_map);

figure, 
subplot(2,1,1)
imagesc(img_map), axis image
subplot(2,1,2)
imhist(img_map);


end