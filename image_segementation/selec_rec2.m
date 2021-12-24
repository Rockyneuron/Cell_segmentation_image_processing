function[]=selec_rec2(im,im2)


 figure, imagesc(im), colormap gray,axis image
     h_rect = imrect();


% % Rectangle position is given as [xmin, ymin, width, height]
pos_rect = h_rect.getPosition();
% Round off so the coordinates can be used as indices
pos_rect = round(pos_rect);
% Select part of the image
img_map1 = im(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));
img_map2 = im2(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));



figure, 
subplot(1,2,1)
imagesc(img_map1), axis image, colormap gray
subplot(1,2,2)
imagesc(img_map2), axis image


end