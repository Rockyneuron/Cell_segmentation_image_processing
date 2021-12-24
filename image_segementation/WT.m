function[g2,w]=WT(I)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Image seg usign watershed transform
%Input
% im......................................Image

%Output:
%totcels: total number en cells taking into account the area


%Arturo Valiño Pérez                                        09/01/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Labbeling conected componentes%
%Utlizando N4 o N8 para definir la adyacencia entre pixels se cuantifica
%cuales estan conectados en la imagen y , por tanto, que forman objetos
%independientes.

%[L,M]=bwlabel(f,conn)


%1) Initial thresholding suing Otsus Method
distcomp.feature( 'LocalUseMpiexec', false )

 %Using the distance transform:
 %1)Obtain binary image
 g=im2bw(I,graythresh(I));
 %2) complement of the image
 gc=~g;
 % Distance transform: Distance from every pixel to te nearest non zero
 % valued pixel
 D=bwdist(gc);
%3)Compute watershed trandsform of the negative of the distance transform.
L=watershed(-D);
% 4)
w=L==0;
g2= g & ~w;
    
figure,
      subplot(2,3,1), 
      imagesc(I), colormap gray, axis image
       subplot(2,3,2),
       imagesc(g), colormap gray, axis image, title('binary')
  subplot(2,3,3),
       imagesc(gc), colormap gray, axis image, title('complement')
  subplot(2,3,4),
       imagesc(D), colormap gray, axis image, title('Distance transform')
 subplot(2,3,5),
       imagesc(w), colormap gray, axis image, title('watershed')
 subplot(2,3,6),
       imagesc(g2), colormap gray, axis image, title('watershed')
       
  
end