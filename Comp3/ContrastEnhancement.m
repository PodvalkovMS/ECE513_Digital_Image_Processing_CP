clc
clear
%%
%Contrast Enhancement

pout = load('Pepsi.mat');
im=pout.pepsi;

I= double(im);

%// Adjust intensities in image I to range from 0 to 1
I = I - min(I(:));
I = I / max(I(:));


pout_histeq16 = histeq(I, 16);
pout_histeq32 = histeq(I, 32);
pout_histeq64 = histeq(I, 64);
figure
montage({pout.pepsi,pout_histeq16,pout_histeq32,pout_histeq64},"Size",[1 4])
title("Original Image and Enhanced Images using  histeq bins 16 32 64 ")

hist=imhist(I);
hist_last16=imhist(pout_histeq16);
hist_last32=imhist(pout_histeq32);
hist_last64=imhist(pout_histeq64);
figure
subplot(2,2,1)
histogram(hist)
title("Original Image histogram ")


subplot(2,2,2)
histogram(hist_last16)
title(" Image histogram histeq bins 16 ")


subplot(2,2,3)
histogram(hist_last32)
title(" Image histogram histeq bins 32  ")


subplot(2,2,4)
histogram(hist_last64)
title(" Image histogram  histeq bins 64 ")


K=zeros(size(I,1),size(I,2));
for i=1:size(I,1)
    for j=1:size(I,2)
        if (i>size(I,1)*1.2/3) && (j<size(I,2)/2) && (i<size(I,1)*2.2/3)
         K(i,j)=I(i,j);
        else
           if (I(i,j)>0.9)
           K(i,j)=1;
           else 
           K(i,j)=I(i,j);    
           end
           if (I(i,j)<0.1)
           K(i,j)=0;
           else
           K(i,j)=I(i,j);
           end
           
        end
    end
end 
figure
imshow(K)
figure
c=imhist(K) ;
histogram(c), title('Design histogram')

t = histeq(I, c);
figure
imshow(t), title('Image with design histogram')


figure
a=imhist(t) ;
histogram(a), title('Histogram of process image')




