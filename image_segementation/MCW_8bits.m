function[g2,bordes]=MCW_8bits(f,T)     


       h=fspecial('sobel');
fd=double(f);
g=sqrt(imfilter(fd,h,'replicate').^2+...
    imfilter(fd,h','replicate').^2);

rm=imregionalmin(g);
im=imextendedmin(f,T); %obtain internal markers
fim=f;
fim(im)=175;

Lim=watershed(bwdist(im)); %obtain external markers
em=Lim==0;

g2=imimposemin(g,im | em);% modifiy grayscale so that regioanl minima occur only on determined locations

L2=watershed(g2); %watersedh transform of the marker modified gradient image
w=L2==mode(L2(:));
g2= g & ~w;



f2=f;
f2(L2==0)=255;
bordes=L2==0;


   figure,
      subplot(2,2,1), 
      imagesc(f), colormap gray, axis image
       subplot(2,2,2),
       imagesc(im), colormap gray, axis image, title('internal markers'), colorbar
  subplot(2,2,3),
       imagesc(Lim), colormap gray, axis image, title('external markers')
  subplot(2,2,4),
       imagesc(L2), colormap gray, axis image, title('marker mod WT')
figure,
       imagesc(f2), colormap gray, axis image, title('marker mod WT')
       
end