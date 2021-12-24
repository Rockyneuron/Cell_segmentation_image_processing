
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cell segmentation implementing the watershed transform

% Load any image at 20x resolution un the script and select Red, green or
% blue channel to count the desired neurons.
%Some functions come from Digital Image Processing book by Gonzalez.
% Depending on the image some functions can be changed to optimize the 
% requieriments for each tye of experiment ( tincion use....etc) that is:

% Median or gaussian filtering and image equalization

            %Arturo Vsliño Pérez                               09/01/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



close all
clear all
addpath('D:\Auto cell counting code\image_segementation')

%Load de FIle
im=mat2gray(imread('NeuN+SST 20x.tiff'));

%Separate color chanels
imred=im(:,:,1);
imgreen=im(:,:,2);
imblue=im(:,:,3);

%View the images
figure, imagesc(im), axis image

figure;
subplot(2,3,1), imagesc(imred),colorbar, axis image, title('Red Channel'), colormap gray
subplot(2,3,4),imhist(imred)
subplot(2,3,2), imagesc(imgreen),colorbar, axis image, title('green Channel'), colormap gray
subplot(2,3,5),imhist(imgreen)
subplot(2,3,3), imagesc(imblue),colorbar, axis image, title('blue Channel'), colormap gray
subplot(2,3,6),imhist(imblue)

%%
%---------------select part of image--------------------------------------

% im=imblue(1000:1100,1000:1100);
[im]=selec_rec(imblue);


%%
%--------------------Apply convolution to increase S2NRatio--------------


w=fspecial('gauss',3,2); %sacamos la mascara
% w=fspecial('average',10); %sacamos la mascara

g_filt=imfilter(im,w,'conv','replicate','same');
g1=im-g_filt;

figure, 
subplot(1,3,1)
imagesc(im), colormap gray, axis image, colorbar, title('raw')
subplot(1,3,2)
imagesc(g_filt), colormap gray, axis image, colorbar, title('filtered')
subplot(1,3,3)
imagesc(g1), colormap gray, axis image, colorbar, title('Raw-filtered')

% g = imsharpen(im);

%%
%--------------Image ecualization------------------------------------------
%Ecualizar imagen
[I]=ecu_im(g_filt,256);
I=im;



%%
%%--- Watershed transform Using the distance transform and otsus 
%-----------------thresholding method------------------------------------%

[WTR,w]=WT(I)    ;
figure,    
    subplot(1,2,1), 
      imagesc(I), colormap gray, axis image,title('Input Image')
       subplot(1,2,2),
       imagesc(WTR), colormap gray, axis image, title('Watershed segmentation')
       
       ind_1=g_filt+w;
       figure,      imagesc(ind_1), colormap gray, axis image,title('Input Image')
       
       example=I+(w*0.5);
       figure,      imagesc(example), colormap gray, axis image,title('Input Image')

       
%%
%--------------   Marker controlled watershed transformation--------------%

%        I=(I);   
%  figure, imagesc(I), axis image           
%    T=2; %height threshold
% %    [MWT]=MCW(I,T); 
%    [MWT]=MCW_8bits(im2uint8(I), T);     
%    
%       figure,    
%     subplot(1,2,1), 
%       imagesc(I), colormap gray, axis image
%        subplot(1,2,2),
%        imagesc(MWT), colormap gray, axis image, title(' Marker controlled Watershed segmentation')

%        
%%                              Count cells
       [tot_cels,RGB]=cell_count(WTR,8);
%        [tot_cels,RGB]=cell_count(MWT,8)    
       
   figure,subplot(1,2,1)
      imagesc(I), colormap gray, axis image, title('input image')
       subplot(1,2,2)    
       imagesc(RGB), colormap gray, axis image, title(['ncels' num2str(tot_cels)])
    
[tot_cels,RGB,seg]=cell_repre(WTR,ind_1,8);
 
figure, imagesc(seg(:,:,1),[0.1 0.7]), axis image, title(['ncels' num2str(tot_cels)]), colormap gray
figure, imagesc(RGB), axis image, title(['ncels' num2str(tot_cels)])

display('selec rectangle for cliser look')
selec_rec2(I,RGB)     
       