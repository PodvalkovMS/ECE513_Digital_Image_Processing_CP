load('Peppers.mat');

text=["2 bits"; "3 bits"; "4 bits"; "5 bits"; "6 bits"; "7 bits" ; "8 bits"];

etalon=peppers;

col=8*ones(64,1);
row=8*ones(64,1);

col2=16*ones(32,1);
row2=16*ones(32,1);

BitPP=2;

images8x8= mat2cell(peppers, col, row );
images16x16= mat2cell(peppers, col2, row2 );

DCT=cell(64);
reconsimage=cell(64);
for i=1:64
   for j=1:64
       DCT{i,j}=dct2(images8x8{i,j}) ;
       DCT{i,j}(abs(DCT{i,j}) < max(DCT{i,j})) = 0;
 
   end
end


DCT16x16=cell(32);
reconsimage16x16=cell(32);
for i=1:32
   for j=1:32
       DCT16x16{i,j}=dct2(images16x16{i,j});
       DCT16x16{i,j}(abs(DCT16x16{i,j}) < max(DCT16x16{i,j})) = 0;
      
       %reconsimage16x16{i,j}=idct2(DCT16x16{i,j})
   end
end


[c2db2,s2db2] = wavedec2(etalon,2,'db4');

[H2db2,V2db2,D2db2] = detcoef2('all',c2db2,s2db2 ,2);
[H1db2,V1db2,D1db2] = detcoef2('all',c2db2,s2db2 ,1);
A2db2 = appcoef2(c2db2,s2db2,'db4');

WaveletDecomposeImageDB2=[A2db2,H2db2;V2db2,D2db2];
[row2db, col2db]=size(WaveletDecomposeImageDB2);

AA2db=zeros(259,259);
for i=1:259
    for j=1:259
    AA2db(i,j)=WaveletDecomposeImageDB2(i,j);
    end
end

twoleveldb=[AA2db, H1db2 ; V1db2,D1db2]; 

[c3db3,s3db3] = wavedec2(etalon,3,'db4');

[H3db3,V3db3,D3db3] = detcoef2('all',c3db3,s3db3 ,3);
[H2db3,V2db3,D2db3] = detcoef2('all',c3db3,s3db3 ,2);
[H1db3,V1db3,D1db3] = detcoef2('all',c3db3,s3db3 ,1);
A3db3 = appcoef2(c3db3,s3db3,'db4');

WaveletDecomposeImageDB3=[A3db3,H3db3;V3db3,D3db3];
[row3db, col3db]=size(WaveletDecomposeImageDB3);


A2db3=zeros(133,133);
for i=1:133
    for j=1:133
    A2db3(i,j)=WaveletDecomposeImageDB3(i,j);
    end
end

A3db3=[A2db3, H2db2 ; V2db2,D2db2]; 


AA3db3=zeros(259,259);
for i=1:259
    for j=1:259
    AA3db3(i,j)=A3db3(i,j);
    end
end

threeleveldb=[AA3db3, H1db3 ; V1db3,D1db3]; 

[c2sym,s2sym] = wavedec2(etalon,2,'sym4');
A2sym2 = appcoef2(c2sym,s2sym,'sym4');
[H2sym2,V2sym2,D2sym2] = detcoef2('all',c2sym,s2sym ,2);
[H1sym2,V1sym2,D1sym2] = detcoef2('all',c2sym,s2sym ,1);

WaveletDecomposeImageSYM2=[A2sym2,H2sym2;V2sym2,D2sym2];
[row2sym, col2sym]=size(WaveletDecomposeImageSYM2);

AA2sym=zeros(259,259);
for i=1:259
    for j=1:259
    AA2sym(i,j)=WaveletDecomposeImageSYM2(i,j);
    end
end

twolevelsym=[AA2sym, H1sym2 ; V1db2,D1sym2]; 


[c3sym3,s3sym3] = wavedec2(etalon,3,'sym4');

[H3sym3,V3sym3,D3sym3] = detcoef2('all',c3sym3,s3sym3 ,3);
[H2sym3,V2sym3,D2sym3] = detcoef2('all',c3sym3,s3sym3 ,2);
[H1sym3,V1sym3,D1sym3] = detcoef2('all',c3sym3,s3sym3 ,1);
A3sym3 = appcoef2(c3sym3,s3sym3,'db4');

WaveletDecomposeImageSYM3=[A3sym3,H3sym3;V3sym3,D3sym3];
[row3sym, col3sym]=size(WaveletDecomposeImageSYM3);


A2sym3=zeros(133,133);
for i=1:133
    for j=1:133
    A2sym3(i,j)=WaveletDecomposeImageSYM3(i,j);
    end
end

A3sym3=[A2sym3, H2sym2 ; V2sym2,D2sym2]; 


AA3sym3=zeros(259,259);
for i=1:259
    for j=1:259
    AA3sym3(i,j)=A3sym3(i,j);
    end
end

threelevelsym=[AA3sym3, H1sym3 ; V1sym3,D1sym3]; 

snr16=zeros(7, 1);
snr=zeros(7, 1);
snr2sym=zeros(7, 1);
snr2db4=zeros(7, 1);
snr3sym4=zeros(7, 1);
snr3db4=zeros(7, 1);

m=1;
for t=2:8

bits=encoding(DCT, t+8, t+8, 8, 8);
DCT_new=decoding(bits, t+8, t+8, 8, 8);

for i=1:64
   for j=1:64
       
       reconsimage{i,j}=idct2(DCT_new{i,j});
   end
end

recimage8x8=cell2mat(reconsimage);
recimage8x8 = uint8(recimage8x8);
etalon=uint8(etalon);


figure
montage({etalon,recimage8x8});
title('Original Grayscale Image partition in 8x8 (Left) and encode and decode Image (Right) '+text(t-1));

[peaksnr,snr(t-1)]=psnr(recimage8x8, etalon);

fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The SNR value is %0.4f \n', snr(t-1));


bits16=encoding(DCT16x16, t+8, t+8, 16, 16);
DCT_new16=decoding(bits16, t+8, t+8, 16, 16);

for i=1:32
   for j=1:32
       reconsimage16x16{i,j}=idct2(DCT_new16{i,j});
   end
end


recimage16x16=cell2mat(reconsimage16x16);
recimage16x16 = uint8(recimage16x16);

figure
montage({etalon,recimage16x16});
title('Original Image partition in 16x16 (Left) and after decode (Right)'+text(t-1));

[peaksnr16,snr16(t-1)]=psnr(recimage16x16, etalon);

fprintf('\n The Peak-SNR value is %0.4f', peaksnr16);
fprintf('\n The SNR value is %0.4f \n', snr16(t-1));


[OutputBitcost, s, c]=wavletencode(WaveletDecomposeImageDB2, row2db, col2db, t);
[cA2db4,cH2db4,cV2db4,cD2db4]=wavletdecode(OutputBitcost, row2db, col2db, s, c);
tut=[cA2db4,cH2db4; cV2db4,cD2db4];

trash=zeros(259,259);
for i=1:259
    for j=1:259
    trash(i,j)=tut(i,j);
    end
end

tam=[trash, H1db2; V1db2,D1db2, ];
ReconstructedImage = idwt2(cA2db4,cH2db4,cV2db4,cD2db4,'db4');
AA=zeros(259,259);
for i=1:259
    for j=1:259
    AA(i,j)=ReconstructedImage(i,j);
    end
end
ReconstructedImage = idwt2(AA,H1db2,V1db2,D1db2,'db4');
figure ;
subplot(1,4, 1),imshow(uint8( etalon)), title('Original image');
subplot(1,4, 2),imshow(uint8( twoleveldb)), title('2 level with DB');
subplot(1,4, 3),imshow(uint8( tam)), title('2 level with DB after decode with '+text(t-1));
subplot(1,4, 4),imshow(uint8( ReconstructedImage)), title('Reconstructed after decode with '+text(t-1));

[peaksnr2db4,snr2db4(t-1)]=psnr(uint8(ReconstructedImage), etalon);

fprintf('\n The Peak-SNR value is %0.4f', peaksnr2db4);
fprintf('\n The SNR value is %0.4f \n', snr2db4(t-1));


[OutputBitcost, s, c]=wavletencode(WaveletDecomposeImageDB3, row3db, col3db, t);
[cA3db3,cH3db3,cV3db3,cD3db3]=wavletdecode(OutputBitcost, row3db, col3db, s, c);
ReconstructedImagedb3 = idwt2(cA3db3,cH3db3,cV3db3,cD3db3, 'db4');
tut=[cA3db3,cH3db3; cV3db3,cD3db3];

cA2db3=zeros(133,133);
A2db3=zeros(133,133);
for i=1:133
    for j=1:133
    A2db3(i,j)=tut(i,j);
    cA2db3(i,j)=ReconstructedImagedb3(i,j);
    end
end

A3db3=[A2db3, H2db2 ; V2db2,D2db2]; 
ReconstructedImage2db3 = idwt2(cA2db3,H2db2 , V2db2,D2db2,  'db4');

cA1db3=zeros(259,259);
AA3db3=zeros(259,259);
for i=1:259
    for j=1:259
    AA3db3(i,j)=A3db3(i,j);
    cA1db3(i,j)=ReconstructedImage2db3(i,j);
    end
end

tam3db=[AA3db3, H1db2; V1db2,D1db2, ];
ReconstructedImage3db3 = idwt2(cA1db3,H1db2,V1db2,D1db2,'db4');
figure ;
subplot(1,4, 1),imshow(uint8( etalon)), title('Original image');
subplot(1,4, 2),imshow(uint8( threeleveldb)), title('3 level with DB');
subplot(1,4, 3),imshow(uint8( tam3db)), title('3 level with DB after decode with '+text(t-1));
subplot(1,4, 4),imshow(uint8( ReconstructedImage3db3)), title('Reconstructed after decode with '+text(t-1));

[peaksnr3db4,snr3db4(t-1)]=psnr(ReconstructedImage3db3, double(etalon));

fprintf('\n The Peak-SNR value is %0.4f', peaksnr3db4);
fprintf('\n The SNR value is %0.4f \n', snr3db4(t-1));



[OutputBitcosts, s, c]=wavletencode(WaveletDecomposeImageSYM2, row2sym, col2sym, t);
[cA2sym,cH2sym,cV2sym,cD2sym]=wavletdecode(OutputBitcosts, row2sym, col2sym, s, c);

tut=[cA2sym,cH2sym; cV2sym,cD2sym];

trash=zeros(259,259);
for i=1:259
    for j=1:259
    trash(i,j)=tut(i,j);
    end
end

tam=[trash, H1sym2; V1sym2,D1sym2, ];

ReconstructedImageS = idwt2(cA2sym,cH2sym,cV2sym,cD2sym,'sym4');
AAs=zeros(259,259);
for i=1:259
    for j=1:259
    AAs(i,j)=ReconstructedImageS(i,j);
    end
end

ReconstructedImageS = idwt2(AAs,H1sym2,V1sym2,D1sym2,'sym4');
figure 
subplot(1,4, 1),imshow(uint8( etalon)), title('Original image');
subplot(1,4, 2),imshow(uint8( twolevelsym)), title('2 level with sym');
subplot(1,4, 3),imshow(uint8( tam)), title('2 level with sym after decode with '+text(t-1));
subplot(1,4, 4),imshow(uint8( ReconstructedImageS)), title('Reconstructed after decode with '+text(t-1));

[peaksnr2sym,snr2sym(t-1)]=psnr(uint8(ReconstructedImageS), etalon);

fprintf('\n The Peak-SNR value is %0.4f', peaksnr2sym);
fprintf('\n The SNR value is %0.4f \n', snr2sym(t-1));



[OutputBitcost, s, c]=wavletencode(WaveletDecomposeImageSYM3, row3sym, col3sym, t);
[cA3sym3,cH3sym3,cV3sym3,cD3sym3]=wavletdecode(OutputBitcost, row3sym, col3sym, s, c);
ReconstructedImagesym3 = idwt2(cA3sym3,cH3sym3,cV3sym3,cD3sym3, 'sym4');
tut=[cA3sym3,cH3sym3; cV3sym3,cD3sym3];

cA2sym3=zeros(133,133);
A2sym3=zeros(133,133);
for i=1:133
    for j=1:133
    A2sym3(i,j)=tut(i,j);
    cA2sym3(i,j)=ReconstructedImagesym3(i,j);
    end
end

A3sym3=[A2sym3, H2sym2 ; V2sym2,D2sym2]; 
ReconstructedImage2sym3 = idwt2(cA2sym3,H2sym2 , V2sym2,D2sym2,  'sym4');

cA1sym3=zeros(259,259);
AA3sym3=zeros(259,259);
for i=1:259
    for j=1:259
    AA3sym3(i,j)=A3db3(i,j);
    cA1sym3(i,j)=ReconstructedImage2sym3(i,j);
    end
end

tam3sym=[AA3sym3, H1sym2; V1sym2,D1sym2, ];
ReconstructedImage3sym3 = idwt2(cA1sym3,H1sym2,V1sym2,D1sym2,'sym4');
figure ;
subplot(1,4, 1),imshow(uint8( etalon)), title('Original image');
subplot(1,4, 2),imshow(uint8( threelevelsym)), title('3 level with sym');
subplot(1,4, 3),imshow(uint8( tam3sym)), title('3 level with sym after decode with '+text(t-1));
subplot(1,4, 4),imshow(uint8( ReconstructedImage3sym3)), title('Reconstructed after decode with '+text(t-1));

[peaksnr3sym4,snr3sym4(t-1)]=psnr(ReconstructedImage3sym3, double(etalon));

fprintf('\n The Peak-SNR value is %0.4f', peaksnr3sym4);
fprintf('\n The SNR value is %0.4f \n', snr3sym4(t-1));


end


x=2:1:8;
figure
plot(x, snr(1:7), x, snr16(1:7));
title('SNR vs BBP');
xlabel('BBP');
ylabel('SNR');
legend('DCT 8x8', 'DCT 16x16' )

snr2db4(1)=0;
snr3db4(1)=0;
snr2sym(1)=0;
snr3sym4(1)=0;

for ul=1:3
snr2db4(ul+1)=snr2db4(ul+1)/(5-ul);
snr3db4(ul+1)=snr3db4(ul+1)/(5-ul);
snr2sym(ul+1)=snr2sym(ul+1)/(5-ul);
snr3sym4(ul+1)=snr3sym4(ul+1)/(5-ul);
end

figure
plot(x, snr2db4(1:7),x, snr3db4(1:7), x, snr2sym(1:7),x, snr3sym4(1:7));
title('SNR vs BBP');
xlabel('BBP');
ylabel('SNR');
legend('DWT 2 level db', 'DWT 3 level db' , 'DWT 2 level sym', 'DWT 3 level sym')









