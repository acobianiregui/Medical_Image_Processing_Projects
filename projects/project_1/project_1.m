%% Question 1

image=imread("Project1_Data\magnified-pollen-dark.tif");
J = histeq(image);

figure
subplot(1,2,1)
imshow(image)
subplot(1,2,2)
imshow(J)

%% Question 2
clear;
image=imread("Project1_Data\hidden-symbols.tif");
J = ...
adapthisteq(image,'NumTiles',[64,64],'clipLimit',0.3,'Distribution','rayleigh');
imshowpair(image,J,'montage');
title('Original Image (left) and Contrast Enhanced Image (right)')
%% Question 3
clear;
image=imread("Project1_Data\fingerprint.png");
%Gamma trasnformation
J = imadjust(image,[],[],0.4);
%J= log(1+ im2double(image));
%Histeq
J1=histeq(image);
threshold=0.04;
%Adapt Histeq
J3=adapthisteq(image,'clipLimit',threshold,'Distribution','rayleigh');
figure
subplot(2,2,1)
imshow(image)
subplot(2,2,2)
imshow(J)
subplot(2,2,3)
imshow(J1)
subplot(2,2,4)
imshow(J3)

%% Question 4

% To be continued