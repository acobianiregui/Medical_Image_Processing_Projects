%% Question 1
clear;
image1 = im2double(imread('Project4_data\yeast-cells.tif')); 
T = adaptthresh(image1, 0.5, 'Statistic', 'gaussian', 'ForegroundPolarity', 'bright'); 
image1New = imbinarize(image1, T); 
figure 
subplot(1,2,1); 
imshow(image1); 
title('Original Image'); 
subplot(1,2,2); 
imshow(image1New); 
title('Thresholded and Binarized Image'); 
[L,n] = bwlabel(image1New);  
regionSize = zeros(n,1);  
for k = 1:n  
regionSize(k)=numel(find(L==k));  
end  
T = sort(regionSize,'descend');  
[~, order] = sort(regionSize, 'descend'); 
keep = order(1:16); 
BWtop = ismember(L, keep); 
figure 
imshow(BWtop) 
title('Largest 16 cells') 
%% Question 2
image2 = im2double(imread('Project4_data\yeast-cells.tif')); 
image2New = image2 > .5; 
figure 
subplot(1,2,1); 
imshow(image2); 
title('Original Image'); 
subplot(1,2,2); 
imshow(image2New); 
title('Manual Thresholding Image'); 
%% Question 3
clear;
Image = imread("Project4_data\dentalXray.tif");
addpath("Project4_data")
figure; 
subplot(2,2,1);
imshow(Image); 
title('Original Dental X-ray Image'); 
% Show filling 
S = 245/ 255; 
T = 0.05; 
[ImageFill, NR,SI,TI] = regiongrow(Image,S,T); 
subplot(2,2,2); 
imshow(ImageFill);
title('Filling'); 
% Show teeth (no filling)
S = 180/ 255; 
T = 0.2; 
[ImageTeeth, NR,SI,TI] = regiongrow(Image,S,T); 
subplot(2,2,3); 
imshow(ImageTeeth); 
title('Teeth (No Filling)');
% Show just background 
S = 70/ 255;  
T = 0.35;  
[ImageBackground, NR, SI, TI] = regiongrow(Image, S, T); 
subplot(2,2,4); 
imshow(ImageBackground); 
title('Background'); 
%% Question 4
%A) !!!!!!!!!
clear all;clc;close all; 
addpath("Project4_data")
g = imread('noisy-elliptical-object.tif'); 
emap1 =snakeMap(g,0.001,15,3,'both'); 
[Fx1, Fy1] = snakeForce(emap1,'MOG'); 
mag = hypot(Fx1,Fy1);  
small=1e-10; 
Fx1= Fx1./(mag +small); 
Fy1= Fy1./(mag +small); 
[x0, y0] = curveManualInput(g,150); 
x1 = x0; 
y1 = y0; 
for i = 1:1000 
[x1,y1] = snakeIterate(0.05, 0.0, 0.6, x1, y1, 1, Fx1, Fy1); 
[x1,y1] = snakeRespace(x1,y1); 
if i == 250 
a1 = x1; 
a2 = y1; 
end 
if i == 500 
b1 = x1;
b2 = y1; 
end 
if i == 750 
c1 = x1;
c2 = y1;
end 
end 
figure, imshow(g); 
hold on;  
curveDisplay(x1,y1,'go','MarkerFaceColor','w');  
figure, imshow(g); 
hold on;  
curveDisplay(a1, a2, 'go','MarkerFaceColor','w');  
figure();  
subplot(2,2,1);  
imshow(g); 
title('250 Iterations'); 
hold on;  
curveDisplay(a1,a2,'go','MarkerFaceColor','w');  
subplot(2,2,2);  
imshow(g); 
title('500 Iterations'); 
hold on;  
curveDisplay(b1,b2,'go','MarkerFaceColor','w');  
subplot(2,2,3);  
imshow(g);  
title('750 Iterations'); 
hold on;  
curveDisplay(c1,c2,'go','MarkerFaceColor','w');  
subplot(2,2,4);  
imshow(g);  
title('1000 Iterations'); 
hold on;  
curveDisplay(x1,y1,'go','MarkerFaceColor','w'); 

%B) !!!!!!!!!!!
% Create a 700x700 gray background image 
A = 0.65 * ones(700, 700); % 0.65 = medium gray (0 = black, 1 = white) 
% Define the size of the black rectangle 
rect_width = 200; 
rect_height = 200; 
% Compute rectangle position (centered) 
x_start = round((700 - rect_width)/2); 
x_end = x_start + rect_width - 1; 
y_start = round((700 - rect_height)/2); 
y_end = y_start + rect_height - 1; 
% Draw the black rectangle in the center 
A(y_start:y_end, x_start:x_end) = 0; % 0 = black 
figure('Color', 'w');  
imshow(A);  
title('Draw an initial mask'); 
h = drawfreehand('Color', [0.2 0.8 0.2], 'LineWidth', 1.5); 
MO = createMask(h);  
MO = imfill (MO, 'holes'); 
its = 1000; % iterations 
BW = activecontour (A, MO, its, 'Chan-Vese'); 
figure('Color', 'w'); 
subplot(1,2,1);
imshow(A);  
hold on; 
visboundaries (MO, 'Color', [0.2 0.8 0.2], 'LineWidth', 1.5); 
subplot(1,2,2); 
imshow(A);  
hold on; 
visboundaries (BW, 'Color', [0.2 0.8 0.2], 'LineWidth', 1.5); 
%% Question 5
clear;

I=imread("Project4_data\fundus_image.png");
I_gray=rgb2gray(I);
numSuper=1000; %Param to optimize
[L,N]=superpixels(I_gray,numSuper);
%
I_hsv=rgb2hsv(I);
V=I_hsv(:,:,3);
%Mean
meanV = zeros(N, 1);
for k = 1:N
    meanV(k) = mean(V(L == k));
end
%
N2=17; %Use elbow criteria to decide!!!!!!
%Kmeans is non-deterministic and repetition is a good idea
[idx,C]=kmeans(meanV,N2,"Replicates",10); 

[~, brightCluster] = max(C);
%
mask = ismember(L, find(idx == brightCluster));
figure;
imshow(mask);
title('Initial Optic Disc Mask');
%Open&close
se = strel('disk', 2);
se2= strel('disk', 10);
mask=imopen(mask,se);
mask=imclose(mask,se2);

%Dice calculation
label_A=mask;
label_B = imread("Project4_data\fundus_label.png");
if size(label_B,3) == 3
    label_B = rgb2gray(label_B);
end
label_B = imbinarize(label_B);

intersection = sum(label_A(:) & label_B(:)); % Intersection
union = sum(label_A(:)) + sum(label_B(:)); % Union
DICE = 2 * intersection / union
figure;
imshowpair(label_B, mask);
title(['Ground Truth (green) vs Predicted (magenta), DICE = ', num2str(DICE)]);

%% K cluster optimization
%meanv in previous section
maxK = 20; 
Ks = 2:maxK;

%Ground truth
B = imread("Project4_data\fundus_label.png");
if size(B,3) == 3
   B = rgb2gray(B);
end
B = imbinarize(B);

sil_avg = nan(size(Ks));
dice_vals = nan(size(Ks));
rng(0); % seed for reproducibility !!!!!!

for i = 1:numel(Ks)
    k = Ks(i);

    %Kmans calculation
    opts = statset('UseParallel',false,'MaxIter',500);
    [idx, C, ~] = kmeans(meanV, k, 'Replicates',10, 'Options', opts);

    % DICE
    [~, brightestCluster] = max(C);
    superpixelIDs = find(idx == brightestCluster); 
    predMask = ismember(L, superpixelIDs);        
    dice_vals(i) = 2 * sum(predMask(:) & B(:)) / (sum(predMask(:)) + sum(B(:)) + eps);
end
figure;
plot(Ks, dice_vals, '-o'); xlabel('k'); ylabel('DICE vs GT'); grid on;





