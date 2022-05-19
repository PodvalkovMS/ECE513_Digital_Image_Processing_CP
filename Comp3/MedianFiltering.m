%MedianFiltering

pout = load('Lena.mat');
im=pout.lena;


I= double(im);
%// Add noise to image

%// Adjust intensities in image I to range from 0 to 1
I = I - min(I(:));
I = I / max(I(:));

for i=1:2:20
I_noisy =  imnoise(I,'salt & pepper',0.02*i);
K3 = medfilt2(I_noisy , [3 3]);
K5 = medfilt2(I_noisy , [5 5]);
K7 = medfilt2(I_noisy , [7 7]);

figure(i)
subplot(1, 5, 1), imshow(I), title('Original image')
subplot(1, 5, 2), imshow(I_noisy), title('Noisy image,')
subplot(1, 5, 3), imshow(K3, []), title('Noisy image, with filter 3')
subplot(1, 5, 4), imshow(K5, []), title('Noisy image, with filter 5')
subplot(1, 5, 5), imshow(K7, []), title('Noisy image, with filter 7')

end