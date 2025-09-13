function [cdf1,level] = cdf_plot(image,ti,limx)

I=image;
if nargin >1 %Recibo titulo
    name=ti;
else 
    name="CDF plot";
end
if nargin > 2 %Recibo xlim
   s=limx;
else 
    s=[0,255];
end
[M,N]=size(I);
[npix,level]=imhist(I);
pdf1=npix/(M*N);
%L=numel(level);
cdf1=cumsum(pdf1);

plot(level,cdf1)
xlim(s)
ylim([0 1.05]); 
title(name)
end