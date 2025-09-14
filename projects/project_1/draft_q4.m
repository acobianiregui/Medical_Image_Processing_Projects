%Independent code to test question 4 solution
I=im2double(imread("Project1_Data\oct_scan.jpeg"));

%I_smooth=zeros(size(I));
%Filtering noise
I_smooth=medfilt2(I,[16 10],"zeros");

%I_smooth(1:95,:)=medfilt2(I(1:95,:),[16 16],"symmetric");
%I_smooth = imgaussfilt(I, 2, 'FilterSize', 13); 

%imshow(I_smooth)
level = graythresh(I_smooth);   % Otsu threshold
mask = I_smooth > level*0.45;    % adjust multiplier if needed
mask=~mask;
I_masked = I_smooth .* mask;

o=I-10*I_masked;

out=adapthisteq(o,'NumTiles',[8,8],'clipLimit',0.01,'Distribution','rayleigh');
out(1:90,:)=out(95,95);
out(400:end,:)=out(95,95);
imshow(out)
