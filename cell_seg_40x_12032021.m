
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------Cell segmentation implementing the watershed transform-------%
%------------------------------------------------------------------------%

% Load any image at 40x resolution un the script and select Red, green or
% blue channel to count the desired neurons.
%Some functions come from Digital Image Processing book by Gonzalez.
% Depending on the image some functions can be changed to optimize the 
% requieriments for each tye of experiment ( tincion use....etc) that is:

% Median or gaussian filtering and image equalization

                                    %Arturo Vsliño Pérez
%                                     09/01/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
addpath('D:\Auto cell counting code\image_segementation')


%Load de FIle
im=mat2gray(imread('Experiment-23-ApoTome-03-Stitching-04Arturo.png'));

%Separate color chanels
imred=im(:,:,1);
% imgreen=im(:,:,2);
% imblue=im(:,:,3);

%View the images
figure, imagesc(im), axis image

figure;
subplot(2,3,1), imagesc(imred),colorbar, axis image, title('Red Channel'), colormap gray
subplot(2,3,4),imhist(imred)
% subplot(2,3,2), imagesc(imgreen),colorbar, axis image, title('green Channel'), colormap gray
% subplot(2,3,5),imhist(imgreen)
% subplot(2,3,3), imagesc(imblue),colorbar, axis image, title('blue Channel'), colormap gray
% subplot(2,3,6),imhist(imblue)

%% select part of image

% im_p=imred(2500:3000,500:1000);
[im_p]=selec_rec(imred);

%%
%-------------------Image ecualization-------------------------------------

[im_equ]=ecu_im(im_p,1000);


%%
%---------------Perform convolution, filetring or other computations------


%------------------median filter------------------------------------------


% m=3;  %tamaño de la mascara
% n=3;
% % im=ordfilt2(im_equ, median(1:m*n), ones(m,n));
% im=ordfilt2(im_p, 2, ones(m,n)); %filtro del percentil 0
% % im=ordfilt2(im, m*n-1, ones(m,n));%filtro del percentil 100

%-----------Other convolutions---------------------------------------------

% im = spfilt(im_equ, 'amean', 3, 3);
% im = spfilt(im_equ, 'hmean', 3, 3);
% im = spfilt(im_equ, 'gmean', 3, 3);
% im = spfilt(im_equ, 'chmean', 3, 3);
% im = spfilt(im_equ, 'median', 3, 3);
% im = spfilt(im_equ, 'max', 3, 3);
% im = spfilt(im_equ, 'min', 3,3);
% im = spfilt(im_equ, 'midpoint', 3,3);
% im = spfilt(im_equ, 'atrimmed', 3,3,6);



im = spfilt(im_equ, 'min', 3,3);
im = spfilt(im, 'amean', 3, 3);

figure,subplot(1,2,1) 
imagesc(im), colormap gray, axis image
subplot(1,2,2) 
imhist(im)




%%
%%----------------Erosions and dilations-----------------------------------

se=strel('disk',3);
fo=imopen(im,se);
foc=imclose(fo,se);

figure, imagesc(foc), colormap gray, axis image
figure, imagesc(fo), colormap gray, axis image

%%
im=foc;
%Apply convolution to increase S2NRatio
w=fspecial('gauss',50,7); %sacamos la mascara
% w=fspecial('average',5);con %sacamos la mascara

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

%----------Edege function, another usufel transofrmation sometimes--------

% 
% close all

% [g,t]=edge(mat2gray(g_filt),'Canny');
% 
% % [g,t]=edge(abs(g1),'Canny',0.5,2);
% % 
% [g,t]=edge(mat2gray(g_filt),'sobel');

[g,t]=edge(mat2gray(g_filt),'log');


figure,
imagesc(g), colormap gray, axis image, colorbar, title('canny')

g_aux=im_p.*~(g==1);

figure, imagesc(g_aux), axis image, colormap gray

%%
%-------------------Image ecualization--------------------------------

[I]=ecu_im(g_filt,1000);
I=mat2gray(g_filt);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Watershed transform Using the distance transform
%----and otsus thresholding method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[WTR,w]=WT(I)    ;
figure,    
    subplot(1,2,1), 
      imagesc(I), colormap gray, axis image,title('Input Image')
       subplot(1,2,2),
       imagesc(WTR), colormap gray, axis image, title('Watershed segmentation')
       
       ind_1=g_filt+w;
       figure,      imagesc(ind_1), colormap gray, axis image,title('Input Image')
       
%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Marker controlled watershed transformation.
       I=(I);   
 figure, imagesc(I), axis image           
   T=25; %height threshold
%    [MWT]=MCW(I,T); 
   [MWT,bordes]=MCW_8bits(imcomplement(im2uint8(mat2gray(I))), T);     
   
      figure,    
    subplot(1,2,1), 
      imagesc(I), colormap gray, axis image
       subplot(1,2,2),
       imagesc(MWT), colormap gray, axis image, title(' Marker controlled Watershed segmentation')

%        
%%  
%------------------Count cells-------------------------------------------


       [tot_cels,RGB]=cell_count(MWT,8);
     im_aux=im_p.*~bordes;
    im_aux_eq=im_equ.*~bordes;
  
   figure,
         imagesc(im_aux), colormap gray, axis image, title('input image')
 figure,
         imagesc(im_aux_eq), colormap gray, axis image, title('input image')

   
   figure,
     subplot(1,3,1)
      imagesc(im_aux), colormap gray, axis image, title('input image')
   subplot(1,3,2)
      imagesc(I), colormap gray, axis image, title('input image')
       subplot(1,3,3)    
       imagesc(RGB), colormap gray, axis image, title(['ncels' num2str(tot_cels)])
    
[tot_cels,RGB,seg]=cell_repre(MWT,ind_1,8) ;      
 
figure, imagesc(seg), axis image, title(['ncels' num2str(tot_cels)])
figure, imagesc(RGB), axis image, title(['ncels' num2str(tot_cels)])

selec_rec2(im_aux,RGB)     
  
%%
%------------------figure of good segmentation example--------------------%


fac=1;
 im_example=mat2gray(im_p).*fac;
 im_example(:,:,2)=bordes*fac;%double(bordes).*fac;
 im_example(:,:,3)=mat2gray(im_p).*fac;

figure, 
imagesc(im_example), axis image, title(['ncels' num2str(tot_cels)])
     
%figure of good segmentation example
 fac=0.8;
im_example=im_p.*~bordes*fac;%double(bordes).*fac;
im_example(:,:,2)=im_p.*~bordes.*fac;%double(bordes).*fac;
 im_example(:,:,3)=im_p.*~bordes.*fac;%double(bordes).*fac;

figure, 
imagesc(im_example), axis image, title(['ncels' num2str(tot_cels)])
     
im_aux=im_p+bordes;
figure,  
imagesc(im_aux), axis image, title(['ncels' num2str(tot_cels)])



