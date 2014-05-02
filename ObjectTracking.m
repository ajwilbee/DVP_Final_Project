
% load the movie to be worked on
load('dissolve.mat')
close all
figure(1)
figure(2)
imMask = mov3(30).cdata;
imColor = mov(30).cdata;
[prevColorObjects,prevgroupings] = Object_SubArray_Extraction(imMask,imColor);
[currColorObjects,currgroupings] = Object_SubArray_Extraction(imMask,imColor);
boxedImage = imColor;
boxColor = [uint8(rand()*255),uint8(rand()*255),uint8(rand()*255)];
[boxedImage] = DrawBoundingBox( boxedImage, prevgroupings{1},boxColor );

[ map,unmappedObjects,missingObjects ] = objectCorrilation( prevColorObjects, currColorObjects );

[ prevColorObjects ] = MapObjects( currColorObjects,map,unmappedObjects,missingObjects );


