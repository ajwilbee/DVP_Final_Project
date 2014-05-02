

load('dissolve.mat')
close all
figure
imshow(mov3(30).cdata*255);
figure
imshow(mov3(31).cdata*255);
im1 = mov3(30).cdata;
[colorObjects] = Object_SubArray_Extraction(im1,mov(30).cdata);