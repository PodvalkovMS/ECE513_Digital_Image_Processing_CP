%%
%SpatialFiltering
pout = load('Lena.mat');
im=pout.lena;


I= double(im);

%// Adjust intensities in image I to range from 0 to 1
I = I - min(I(:));
I = I / max(I(:));

%// Add noise to image
v = var(I(:)) / sqrt(10);
I_noisy = imnoise(I, 'gaussian', 0, v);

%// Show images
%figure
%subplot(1, 2, 1), imshow(I), title('Original image')
%subplot(1, 2, 2), imshow(I_noisy), title('Noisy image, SNR=5db')



boxKernel2 = ones(2,2); % Or whatever size window you want.
blurredImage2 = conv2(I_noisy, boxKernel2, 'same');


boxKernel4 = ones(4,4); % Or whatever size window you want.
blurredImage4 = conv2(I_noisy, boxKernel4, 'same');


boxKernel8 = ones(8,8); % Or whatever size window you want.
blurredImage8 = conv2(I_noisy, boxKernel8, 'same');

figure
subplot(1, 5, 1), imshow(I), title('Original image')
subplot(1, 5, 2), imshow(I_noisy), title('Noisy image, SNR=5db')
subplot(1, 5, 3), imshow(blurredImage2, []), title('Noisy image, with filter 2')
subplot(1, 5, 4), imshow(blurredImage4, []), title('Noisy image, with filter 4')
subplot(1, 5, 5), imshow(blurredImage8, []), title('Noisy image, with filter 8')



[peaksnr, snr] = psnr(I, blurredImage2);
  

fprintf('\n The SNR value is %0.4f \n', snr);

[peaksnr, snr] = psnr(I, blurredImage4);

fprintf('\n The SNR value is %0.4f \n', snr);


[peaksnr, snr] = psnr(I, blurredImage8);
 
fprintf('\n The SNR value is %0.4f \n', snr);

figure
 subplot(1, 3, 1),  freqz2(boxKernel2,[32 32]), title('filter 2')
 subplot(1, 3, 2),  freqz2(boxKernel4,[32 32]), title('filter 4')
 subplot(1, 3, 3),  freqz2(boxKernel8,[32 32]), title('filter 8')

