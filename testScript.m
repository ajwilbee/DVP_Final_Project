close all
clear all
load('MaskImage.mat');

im = workingImage;
%bring mask back down may take this out later after all testing is done
im = im/255;
[cm,finalmap] = Grouping(im);
imshow(cm)

segmentIm = uint8(zeros(size(im,1),size(im,2),3));
for x = 1:length(finalmap)
   temp = cm==finalmap(x);
    r = uint8(temp*rand()*255);
    g = uint8(temp*rand()*255);
    b = uint8(temp*rand()*255);
    tempcolor = cat(3,r,g,b);
    tempcolor = tempcolor(2:end-1,2:end-1,:);
    segmentIm = segmentIm+tempcolor; %eliminate the padding
    
end
figure
imshow(segmentIm)