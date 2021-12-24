function[tot_cels,RGB,seg]=cell_repre(im,im2,con)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Counts cells of a binary image
% im......................................Image
% con.....................................4 or 8 to select connected elements    
% area....................................mean cell area

%Output:
%totcels: total number en cells taking into account the area


%09/01/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Labbeling conected componentes%
%Utlizando N4 o N8 para definir la adyacencia entre pixels se cuantifica
%cuales estan conectados en la imagen y , por tanto, que forman objetos
%independientes.

%[L,M]=bwlabel(f,conn)


[L,M]=bwlabel(im,con); %veo y distingo los elementos que estan conectados
% figure, imagesc(L), colormap jet, axis image

%identifico los elementos
nel=max(L(:)); %numero de elementos diferentes
work_label=[];
work_area=[];
for i=1:nel
   [row,col]=find(L==i);
   Mrow=mean(row(:));
   Mcol=mean(col(:));
   area=size(row,1);
   work_label=[work_label [ Mrow;Mcol]];
     work_area=[work_area area];
end

M_nuclei=mean(work_area);
ncels=round(work_area./M_nuclei);
ncels(ncels==0)=1;
tot_cels=sum(ncels);

figure,
imagesc(im), hold on, axis image
plot(work_label(2,:),work_label(1,:),'o')
title(['number of cells' num2str(tot_cels)])

text_str = cell(size(ncels,2),1);
for ii=1:size(ncels,2)
   text_str{ii} =  num2str(ncels(ii));
end


RGB = insertText(double(im),[work_label(2,:)',work_label(1,:)'],text_str,'FontSize',9,...
    'BoxOpacity',0,'TextColor','blue','AnchorPoint','Center' );

seg = insertText(double(im2),[work_label(2,:)',work_label(1,:)'],text_str,'FontSize',9,...
    'BoxOpacity',0,'TextColor','blue','AnchorPoint','Center' );



% figure, imagesc(RGB), axis image

figure, hist(ncels);

% figure, plot(work_area,'.')
% figure, hist(work_area)




end