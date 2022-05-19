function [cA1,cH1,cV1,cD1]=wavletdecode(OutputBitcost, row, col, s, c)
quantizedvalue=1;

g=length(s);
j=1;
l=1;
for i=1:g
 v(l)=s(j);
 if c(j)~=0
 w=l+c(j)-1;
 for p=l:w
 v(l)=s(j);
 l=l+1;
 end
 end
 j=j+1;
end
ReconstructedImageArray=v;
%Inverse ZigZag
ReconstructedImage=invzigzag(ReconstructedImageArray,row,col);
% Inverse Quantization
ReconstructedImage=ReconstructedImage*quantizedvalue;

% Wavelet Reconstruction
sX = size(ReconstructedImage);
cA1 = ReconstructedImage(1:(sX(1)/2), 1:(sX(1)/2));
cH1 = ReconstructedImage(1:(sX(1)/2), (sX(1)/2 + 1):sX(1));
cV1 = ReconstructedImage((sX(1)/2 + 1):sX(1), 1:(sX(1)/2));
cD1 = ReconstructedImage((sX(1)/2 + 1):sX(1), (sX(1)/2 + 1):sX(1));

end