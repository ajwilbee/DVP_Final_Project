
% load the movie to be worked on
load('dissolve.mat')
close all
imMask = mov3(30).cdata;
imColor = mov(30).cdata;
[prevColorObjects,prevgroupings] = Object_SubArray_Extraction(imMask,imColor);
[currColorObjects,currgroupings] = Object_SubArray_Extraction(imMask,imColor);
boxedImage = imColor;
boxColor = [uint8(rand()*255),uint8(rand()*255),uint8(rand()*255)];
[boxedImage] = DrawBoundingBox( boxedImage, prevgroupings{1},boxColor );

[ map,unmappedObjects,missingObjects ] = objectCorrilation( prevColorObjects, currColorObjects );
initialize = 1;
colorMap = {[]};
[ prevColorObjects,prevgroupings,colorMap ] = MapObjects( currColorObjects,currgroupings,map,unmappedObjects,missingObjects,colorMap,initialize);

for x = 1:length(prevColorObjects)
   
    figure, imshow(prevColorObjects{x});
    figure, imshow(prevgroupings{x});
    [ imColor ] = DrawBoundingBox( imColor, prevgroupings{x},colorMap{x} );
end
figure, imshow(imColor);
initialize = 0;

