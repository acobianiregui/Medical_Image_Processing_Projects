%% Question 1
clear;
I=imread("Project1_Data\magnified-pollen-dark.tif");
cdf_plot(I,"CDF before"); %Handmade function, check .m file
J = histeq(I);
cdf_plot(J,"CDF after");
figure
subplot(1,2,1)
imshow(I)
subplot(1,2,2)
imshow(J)

%% Question 2
clear;
I=imread("Project1_Data\hidden-symbols.tif");
cdf_plot(I,"CDF before");

J = ...
adapthisteq(I,'NumTiles',[64,64],'clipLimit',0.3,'Distribution','rayleigh');
figure
cdf_plot(J,"CDF after");

figure
imshowpair(I,J,'montage');
title('Original Image (left) and Contrast Enhanced Image (right)')
%% Question 3
clear;
I=imread("Project1_Data\fingerprint.png");
%Gamma trasnformation
cdf_plot(I,"CDF before");
J = imadjust(I,[],[],0.9);
%J= log(1+ im2double(image));
%Histeq
J1=histeq(I);
figure
cdf_plot(J1,"CDF after");
threshold=0.04;
%Adapt Histeq

J3=adapthisteq(I,'clipLimit',threshold,'Distribution','rayleigh');
figure
subplot(2,2,1)
imshow(I)
subplot(2,2,2)
imshow(J)
subplot(2,2,3)
imshow(J1)
subplot(2,2,4)
imshow(J3)

%% Question 4
clear;

I=im2double(imread("Project1_Data\oct_scan.jpeg"));
%Filtering noise (Keeping the noise to substract later)
I_smooth=medfilt2(I,[16 10],"zeros");

%Apply threshold & substract mask from orginal image
level = graythresh(I_smooth);
mask = I_smooth > level*0.45;   
mask=~mask;
I_masked = I_smooth .* mask;

o=I-10*I_masked; % x10 was shown to be a good factor
%Finally, adaptive histogram equalization 
out=adapthisteq(o,'NumTiles',[8,8],'clipLimit',0.01,'Distribution','rayleigh');
out(1:90,:)=out(95,95);
out(400:end,:)=out(95,95);
imshow(out)
