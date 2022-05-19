%EdgeSharpening

pout = load('Boat.mat');
im=pout.boat;


I= double(im);
%// Add noise to image

%// Adjust intensities in image I to range from 0 to 1
I = I - min(I(:));
I = I / max(I(:));

figure 
imshow(I), title('Original images')

sigma=0.02
BW1 = edge(I,'Sobel' ,[ ]);
BW2 = edge(I,'Prewitt', [ ]);
BW3 = edge(I,'Roberts', [ ]);
BW4 = edge(I,'log', sigma);
n=ceil(sigma*3)*2+1
figure
 subplot(2, 2, 1),  imshow(BW1), title('Sobel')
 subplot(2, 2, 2),  imshow(BW2), title('Prewitt')
 subplot(2, 2, 3),  imshow(BW3), title('Roberts')
 subplot(2, 2, 4),  imshow(BW4), title('3x3 Laplacian')
 
new1=I+0.2*BW1; 
new2=I+0.2*BW2; 
new3=I+0.2*BW3;   
new4=I+0.2*BW4;

figure
 subplot(2, 2, 1),  imshow(new1), title('Sobel')
 subplot(2, 2, 2),  imshow(new2), title('Prewitt')
 subplot(2, 2, 3),  imshow(new3), title('Roberts')
 subplot(2, 2, 4),  imshow(new4), title('3x3 Laplacian')
 



 



