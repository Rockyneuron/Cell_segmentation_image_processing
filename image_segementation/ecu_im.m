function[J]=ecu_im(im,x)

%Image Ecualization
%im.............image
%x...........n bins for ecualization

J=histeq(im,x);

figure,
subplot(2,2,1), imagesc(im), colormap gray, axis image, colorbar
subplot(2,2,2),imhist(im);
subplot(2,2,3),imagesc(J), colormap gray, axis image, colorbar
 subplot(2,2,4),imhist(J);
 
 
% % % % %  Too see normalized hisrograms uncomment

 raw_h=(imhist(im)./numel(im));
 conv_h=(imhist(J)./numel(J));

 figure, 
 bar(raw_h), colormap gray
  figure, 
 bar(conv_h), colormap gray


end



