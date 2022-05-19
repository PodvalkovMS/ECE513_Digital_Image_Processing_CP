function [OutputBitcost, s, c]=wavletencode(WaveletDecomposeImage, row, col, BitPP)
quantizedvalue=1;

QuantizedImage= WaveletDecomposeImage/quantizedvalue;
QuantizedImage= round(QuantizedImage);
ImageArray = zigzag(QuantizedImage);
% Run Length Encoding
j=1;
a=length(ImageArray);
count=0;
for n=1:a
 b=ImageArray(n);
 if n==a
 count=count+1;
 c(j)=count;
 s(j)=ImageArray(n);
 elseif ImageArray(n)==ImageArray(n+1)
 count=count+1;
 elseif ImageArray(n)==b;
 count=count+1;
 c(j)=count;
 s(j)=ImageArray(n);
 j=j+1;
 count=0;
 end
end
InputBitcost=row*col*BitPP;
InputBitcost=(InputBitcost);
c1=length(c);
s1=length(s);
OutputBitcost= (c1*BitPP)+(s1*BitPP);
OutputBitcost=(OutputBitcost);
end