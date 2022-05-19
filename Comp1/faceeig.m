clc
clear

r = 243;
c = 320;

h = 243;
w = 320;


imagedir = "Faces/yalefaces";

%% Image whic not include in dataset

imTEST = imread('yaleB11_P00A+020E-10.pgm')
imTEST =imresize(imTEST  ,[r, c]);
imagesc(imTEST);

[x,y] = ginput(1);
    
x_shift = cast(-1*(x-(w/2)), 'int32');
y_shift = cast(-1*(y-(h/2)), 'int32');
    
imTEST= circshift(imTEST, x_shift,2);
imTEST = circshift(imTEST, y_shift,1);

TEST = reshape(imTEST,r*c,1);

%%  Find Eieg images of happy set


imagefiles = dir(fullfile(imagedir,"*.gif"));

r = 243;
c = 320;

[X,Y]=take_data(imagedir,3)

[eigenfaces , eigenfaces_value, mu]=find_value_and_image(X)

x_reconstract=reconstruct(X(:,3), eigenfaces , eigenfaces_value, mu)

trash = reshape(x_reconstract ,[r, c]);
figure;
imagesc(trash);

train_tresh=reshape(X(:,3) ,[r, c]);
figure;
imagesc(train_tresh);

SNR= snr( double(x_reconstract), double(X(:,3)))

pause
%%  Check not unclude images with happy eiges images

SNR_n=[]

noize=0

for j=1:4
  
y_reconstract(:,j)=reconstruct(Y(:,j), eigenfaces , eigenfaces_value, mu)
trash = reshape(y_reconstract(:,j) ,[r, c]);
figure;
imagesc(trash);

train_tresh=reshape(Y(:,j) ,[r, c]);
figure;
imagesc(train_tresh);

noize=snr(double(y_reconstract(:,j)),double(Y(:,j)))+noize
SNR_n=[SNR_n snr(double(y_reconstract(:,j)),double(Y(:,j)))]


end

Noize=abs(noize)/4

%% Use 2/3 data set as train and least as test 


[X_all,Y_all]=take_data(imagedir,0)

[eigenfaces_all , eigenfaces_value_all, mu_all]=find_value_and_image(X_all)

x_all_reconstract=reconstruct(X_all(:,7), eigenfaces_all , eigenfaces_value_all, mu_all)

trash = reshape(x_all_reconstract ,[r, c]);
figure;
imagesc(trash);

train_tresh=reshape(X(:,7) ,[r, c]);
figure;
imagesc(train_tresh);

SNR_all= snr(double(x_all_reconstract),double(X_all(:,7)))
pause


SNR_all_n=[]
error=0

for j=1:size(Y_all,2)
  
y_all_reconstract(:,j)=reconstruct(Y_all(:,j), eigenfaces_all , eigenfaces_value_all, mu_all)


error=snr(double(y_all_reconstract(:,j)),double(Y_all(:,j)))+error

SNR_all_n=[SNR_all_n snr(double(y_all_reconstract(:,j)),double(Y_all(:,j)))]



end

Error=abs(error)/size(Y_all,2)

%% Test image whic not include
TEST_rec=reconstruct(TEST, eigenfaces_all , eigenfaces_value_all, mu_all)

trash = reshape(TEST_rec ,[r, c]);
figure;
imagesc(trash);

train_tresh=reshape(TEST ,[r, c]);
figure;
imagesc(train_tresh);

pause

%% Create a classifiacation sad happy 

[X_SAD Y_SAD]=take_data(imagedir,7)

[eigenfaces_SAD , eigenfaces_value_SAD, mu_SAD]=find_value_and_image(X_SAD)


for j=1:size(X_SAD,2)
  
x_sad_reconstract(:,j)=reconstruct(X_SAD(:,j), eigenfaces_SAD , eigenfaces_value_SAD, mu_SAD)
x_happy_reconstract(:,j)=reconstruct(X(:,j), eigenfaces , eigenfaces_value, mu)

end


X_SAD_MEAN = mean(x_sad_reconstract,2)
X_HAPPY_MEAN = mean(x_happy_reconstract,2)


y__test_sad_reconstract=reconstruct(X_SAD(:,5), eigenfaces_SAD , eigenfaces_value_SAD, mu_SAD)
y__test_happy_reconstract=reconstruct(X_SAD(:,5), eigenfaces , eigenfaces_value, mu)

sad_dist= norm(double(X_SAD_MEAN) - double(y__test_sad_reconstract));
happy_dist= norm(double(X_HAPPY_MEAN) - double(y__test_happy_reconstract));


if sad_dist>=happy_dist 
trash = reshape(X_SAD(:,5) ,[r, c]);
figure( 'Name', 'sad');
imagesc(trash);
disp("The image is sad");
hold on
else
trash = reshape(X_SAD(:,5) ,[r, c]);
figure( 'Name', 'happy');
imagesc(trash);
disp("The image is happy");
hold on
end
hold off
