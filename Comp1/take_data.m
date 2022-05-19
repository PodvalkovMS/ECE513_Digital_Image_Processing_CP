function [X,Y]=take_data(imagedir, flag)


imagefiles = dir(fullfile(imagedir,"*.gif"));

h = 243;
w = 320;

X=[]
Y=[]
if flag>0 
    NAMES=["centerlight"; "glasses" ;"happy"; "leftlight" ;"nonglasses"; "normal"; "sad" ;"sleepy" ;"suprised" ;"wink"]
   
    counter=0
    for i = 1:length(imagefiles)
        
        k = strfind(imagefiles(i).name, NAMES(flag))
        if not(isempty(k))  
        file = fullfile(imagedir, imagefiles(i).name);
        
        im = imread(file);
        [r c] = size(im);
        temp = reshape(im,r*c,1);
        X = [X temp];
        else 
            if counter<5 
            file = fullfile(imagedir, imagefiles(i).name);
           
            im = imread(file);
            [r c] = size(im);
            temp = reshape(im,r*c,1);
            Y = [Y temp];
            end
            
        end
    
    end
    
else
    for i = 1:length(imagefiles)
    if i<(2*floor(length(imagefiles)/3))
        
        file = fullfile(imagedir, imagefiles(i).name);
        
        im = imread(file);
        [r c] = size(im);
        temp = reshape(im,r*c,1);
        X = [X temp];
    
    else
        file = fullfile(imagedir, imagefiles(i).name);
           
        im = imread(file);
        [r c] = size(im);
        temp = reshape(im,r*c,1);
        Y = [Y temp];
        
    end
        
    
    end   
end
end