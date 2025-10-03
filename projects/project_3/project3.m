%% Question 1
clear
%% 1
image1 = imread('Project3_data\mixed-squares.tif');
imageNew = imerode(image1, ones(28));
figure
subplot(1,2,1);
imshow(image1);
title('Original Image');
subplot(1,2,2);
imshow(imageNew);
title('Eroded Image');
saveas(gcf, "results/erode_squares.png");
%% Question 2
clear
Image = imread("Project3_data\subcellimage.png");
se = strel('disk', 50);
ImageNew=imopen(Image, se);
figure;
subplot(1,2,1);
imshow(Image);
title("Original Image");
subplot(1,2,2);
imshow(ImageNew);
title("Altered Image");
saveas(gcf, "results/subcell.png");
%% Question 3
clear
Image = imread("Project3_data\thumbprint.tif");
% Open image
se = strel('square',4);
To = imopen(Image,se);
% Open then close
Toc = imclose(To,se);
figure;
subplot(1,3,1);
imshow(Image);
title("Original Image");
subplot(1,3,2);
imshow(To);
title("Opened Image");
subplot(1,3,3);
imshow(Toc);
title("Opened then Closed Image");
saveas(gcf, "results/thumbprint.png");
%% Question 4
clear
%a)
I=imread("Project3_data\stromalcells.tif");
%b) Object identification
L=bwlabel(I);
Number_of_objects=max(L(:));
%c) 
figure
imshow(L)
disp(Number_of_objects) %It's 22
%d)
cc=bwconncomp(I);
L = labelmatrix(cc);
ColorImage = label2rgb(L,'jet',[0.7 0.7 0.7],'shuffle');
%e)
figure
imshowpair(I,ColorImage,"montage")
saveas(gcf, "results/strom_cells.png");
%% Question 5
%1. Read image and extract green channel
fundus = imread('Project3_data\fundus_image.jpg');
greenChannel = fundus(:,:,2);
%2. Enhance vessels with black-hat transform
se = strel('disk',10);
blackhat = imbothat(greenChannel, se);
%3. Threshold to create binary mask
bw = imbinarize(blackhat);
%4. Remove small objects
bw_clean = bwareaopen(bw, 200);
%5. Morphological closing (connect broken vessels)
se2 = strel('disk', 2);
bw_closed = imclose(bw_clean, se2);
%6. Skeletonization
skeleton = bwmorph(bw_closed, 'skel', Inf);
%7. Plot results
figure;
subplot(1,3,1), imshow(greenChannel), title('Green Channel');
subplot(1,3,2), imshow(bw_closed), title('Binary Vessel Mask');
subplot(1,3,3), imshow(skeleton), title('Skeletonized Vessels');
saveas(gcf, "results/fundus.png");