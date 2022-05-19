pout = load('Lena.mat');
im=pout.lena;


PSF = fspecial('motion', 20);
Idouble = im2double(im);
blurred = imfilter(Idouble,PSF,'conv','circular');


wnr1 = deconvwnr(blurred,PSF);


figure
subplot(1, 3, 1) , imshow(Idouble, [0 255]), title('Original image')
subplot(1, 3, 2) , imshow(blurred, [0 255]), title('Blurred Image')
subplot(1, 3, 3), imshow(wnr1, [0 255]), title('Restored Blurred Image')
pause 

I= double(im);

%// Adjust intensities in image I to range from 0 to 1
I = I - min(I(:));
I = I / max(I(:));

%// Add noise to image
v = var(I(:));
I_noisy = imnoise(I, 'gaussian', 0, v);

[~, snr] = psnr(I_noisy,  I);
fprintf('\n The SNR value of noise image is %0.4f  ', snr);

[K,~] = wiener2(I_noisy,[5 5]);

[~, snr] = psnr(K,  I);
fprintf('\n The SNR value of clear image is %0.4f \n', snr);

figure
subplot(1, 3, 1) , imshow(Idouble, [0 255]), title('Original image')
subplot(1, 3, 2) , imshow(I_noisy), title('Noise Image')
subplot(1, 3, 3), imshow(wnr1, [0 255]), title('Restored Noise Image')

pause


%// Adjust intensities in image I to range from 0 to 1

v = var(blurred(:))*0.00005;
blurred=uint8(blurred);
blurred_noisy = imnoise(blurred,'gaussian',0, v);

Idouble=uint8(Idouble);
[~, snr] = psnr(blurred_noisy,  Idouble);
fprintf('\n The SNR value of blured and noise image is %0.4f', snr);

signal_var = var(im2double(blurred_noisy(:)));
NSR = v +signal_var;
rec = deconvwnr(blurred_noisy,PSF, NSR );


[~, snr] = psnr(rec,  Idouble);
fprintf('\n The SNR value of blured and noise image is %0.4f \n', snr);




figure
subplot(1, 3, 1) , imshow(Idouble, [0 255]), title('Original image')
subplot(1, 3, 2) , imshow(blurred_noisy, [0 255]), title('Blured and Noise Image')
subplot(1, 3, 3), imshow(rec ,[0 255]), title('Restored Blured and Noise Image')


