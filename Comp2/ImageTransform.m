load('Peppers.mat')

etalon=peppers

col=8*ones(64,1)
row=8*ones(64,1)

col2=16*ones(32,1)
row2=16*ones(32,1)



images8x8= mat2cell(peppers, col, row );
images16x16= mat2cell(peppers, col2, row2 );

DCT=cell(64);
reconsimage=cell(64);
for i=1:64
   for j=1:64
       DCT{i,j}=dct2(images8x8{i,j}) ;
       DCT{i,j}(abs(DCT{i,j}) < max(DCT{i,j})) = 0;
       reconsimage{i,j}=idct2(DCT{i,j});
   end
end

recimage8x8=cell2mat(reconsimage)
recimage8x8 = rescale(recimage8x8);
etalon=rescale(etalon)

figure
montage({etalon,recimage8x8})
title('Original Grayscale Image partition in 8x8 (Left) and Processed Image (Right)');

[peaksnr,snr]=psnr(recimage8x8, etalon)

fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The SNR value is %0.4f \n', snr);

recimage8x8 = wcodemat(recimage8x8,255,'mat',1);


DCT16x16=cell(32)
reconsimage16x16=cell(32)
for i=1:32
   for j=1:32
       DCT16x16{i,j}=dct2(images16x16{i,j}) 
       DCT16x16{i,j}(abs(DCT16x16{i,j}) < max(DCT16x16{i,j})) = 0;
       reconsimage16x16{i,j}=idct2(DCT16x16{i,j})
   end
end

recimage16x16=cell2mat(reconsimage16x16)
recimage16x16 = rescale(recimage16x16);

figure
montage({etalon,recimage16x16})
title('Original Grayscale Image partition in 16x16 (Left) and Processed Image (Right)');

[peaksnr16,snr16]=psnr(recimage16x16, etalon)

fprintf('\n The Peak-SNR value is %0.4f', peaksnr16);
fprintf('\n The SNR value is %0.4f \n', snr16);

recimage16x16 = wcodemat(recimage16x16,255,'mat',1);


etalon = wcodemat(etalon,255,'mat',1);


[c2db4,s2db4] = wavedec2(etalon,2,'db4');
rec2db4 = waverec2(c2db4,s2db4,'db4');
A2db4 = appcoef2(c2db4,s2db4,'db4');
figure
A2db4img = wcodemat(A2db4,255,'mat',1);
imagesc(rec2db4 )
title('Recontract Image two level decompositions with Daubechies wavelets (db4)');
rec2db4 = rescale(rec2db4);
[peaksnr2db4,snr2db4]=psnr(rec2db4, etalon)

fprintf('\n The Peak-SNR value is %0.4f', peaksnr2db4);
fprintf('\n The SNR value is %0.4f \n', snr2db4);


[c3db4,s3db4] = wavedec2(etalon,3,'db4');
rec3db4 = waverec2(c3db4,s3db4,'db4');
A3db4 = appcoef2(c3db4,s3db4,'db4');
figure
A3db4img = wcodemat(A3db4,255,'mat',1);
imagesc(rec3db4 )
title('Recontract Coef of Processed Image three level decompositions with Daubechies wavelets (db4)');
rec3db4 = rescale(rec3db4);
[peaksnr3db4,snr3db4]=psnr(rec3db4, etalon)

fprintf('\n The Peak-SNR value is %0.4f', peaksnr3db4);
fprintf('\n The SNR value is %0.4f \n', snr3db4);


[c2sym,s2sym] = wavedec2(etalon,2,'sym4');
rec2sym = waverec2(c2sym,s2sym,'sym4');
A2sym = appcoef2(c2sym,s2sym,'sym4');
figure
A2symimg = wcodemat(A2sym,255,'mat',1);
imagesc(rec2sym )
title('Reconsruct Coef of Processed Image two level decompositions with Symlet wavelets (sym)');
rec2sym = rescale(rec2sym);
[peaksnr2sym,snr2sym]=psnr(rec2sym, etalon)

fprintf('\n The Peak-SNR value is %0.4f', peaksnr2sym);
fprintf('\n The SNR value is %0.4f \n', snr2sym);


[c3sym,s3sym] = wavedec2(etalon,3,'sym4');
rec3sym = waverec2(c2sym,s2sym,'sym4');
A3sym = appcoef2(c3sym,s3sym,'sym4');
figure
A3symimg = wcodemat(A3sym,255,'mat',1);
imagesc(rec3sym )
title('Recontract Coef of Processed Image three level decompositions with Symlet wavelets (sym)');
rec3sym = rescale(rec3sym);
[peaksnr3sym,snr3sym]=psnr(rec3sym, etalon)

fprintf('\n The Peak-SNR value is %0.4f', peaksnr3sym);
fprintf('\n The SNR value is %0.4f \n', snr3sym);
   
