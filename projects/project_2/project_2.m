%% Question 1
% a) PLot
clear;
I=imread("Project2_data\liver-cells-gray.tif");
figure
imshow(I);
%b) 
f=fspecial("laplacian", 0);
out1=imfilter(I,f);
figure;
subplot(1,2,1)
imshow(I,[]); %Keep in mind [] adjusts lims to image values
subplot(1,2,2);
imshow(out1,[]);
%c)
out2=I-out1;
figure
imshow(out2,[]);
title("Substraction c)")
%d)
I_double=im2double(imread('Project2_data\liver-cells-gray.tif'));
f=fspecial('laplacian', 0.2);
out3=imfilter(I_double,f);
figure;
title("ergerh")
subplot(1,3,1)
imshow(I_double,[]);
subplot(1,3,2);
imshow(out1,[]);
subplot(1,3,3);
imshow(out3);
%e)
out4=I_double-out3;
figure;
imshow(out4,[]);
title("Subsctraction e)");
%f)
m=max(max(out1));
figure

imshowpair(out1,uint8(out3*double(m)/255),"montage")
title("b) and d) comparison");
figure
imshowpair(out2,double(m)*out4/255,"montage")
title("c) and e) comparison")
I_int=imread("Project2_data\liver-cells-gray.tif");
%% Question 2
clear;
dental_p=imread("Project2_data\dentalXray-pepper-noise.tif");
dental_s=imread("Project2_data\dentalXray-salt-noise.tif");
%b)
addpath('./Project2_data/') %To import functions in projectData2

med_p=medfilt2(dental_p,[3 3]);
ord_p=ordfilt2(dental_p,9,ones(3,3));
min_p=minfilter(im2double(dental_p),3,3);
max_p=maxfilter(im2double(dental_p),3,3);
figure;
title("Filtering pepper noise")
subplot(2,2,1)
imshow(med_p);
title("Med filter")
subplot(2,2,2)
imshow(ord_p,[]);
title("Ord filter")
subplot(2,2,3)
imshow(max_p);
title("Maxfilter")
subplot(2,2,4)
imshow(min_p);
title("Min filter")


med_s=medfilt2(dental_s,[3 3]);
ord_s=ordfilt2(dental_s,1,ones(3,3));
min_s=minfilter(im2double(dental_s),3,3);
max_s=maxfilter(im2double(dental_s),3,3);
figure;
title("Filtering pepper noise")
subplot(2,2,1)
imshow(med_s);
title("Med filter")
subplot(2,2,2)
imshow(ord_s);
title("Ord filter")
subplot(2,2,3)
imshow(max_s);
title("Maxfilter")
subplot(2,2,4)
imshow(min_s);
title("Min filter")

saveas(gcf,"image_ouputs\salt_noise_filters.png")
%% Question 3
%Load picture from project 1
clear;
I=imread("..\project_1\output\oct_scan_clean.png");
threshold=30;  %Need threshold (background is not exactly 0)
[i_all, j_all, v_all] = find(I>threshold);
%Find first pixels whose value is greater than the threshold
t = logical(diff([0; j_all]));
i = i_all(t); %Row indices
j = j_all(t); %Column index
v = v_all(t); %Values
mask=zeros(size(I)); %Inizialiate mask matrix
%Loop to fill expected layer
for x1=1:numel(i)
    mask(i(x1),j(x1))=v(x1);
end

%Now apply red color to mask
I_color=cat(3,I,I,I);
red_chanel=I_color(:,:,1);
green_chanel=I_color(:,:,2);
blue_chanel=I_color(:,:,3);

red_chanel(mask>0)=255;
green_chanel(mask>0)=0;
blue_chanel(mask>0)=0;

I_color(:,:,1)=red_chanel;
I_color(:,:,2)=green_chanel;
I_color(:,:,3)=blue_chanel;
figure
title("Upper border detection")
%imshowpair(mask,I,"montage")
imshow(I_color)

%ALTERNATIVE: just plot the colored mask over the original
% Save images 
%imwrite(mask,"image_ouputs\mask.png")
%imwrite(I_color,"image_ouputs\colored_border.png")
