

load('dissolve.mat')
close all
figure(1)
imshow(mov3(30).cdata*255);
figure(2)
imshow(mov3(31).cdata*255);
imMask = mov3(30).cdata;
imColor = mov(30).cdata;
[prevColorObjects] = Object_SubArray_Extraction(imMask,imColor);
[currColorObjects] = Object_SubArray_Extraction(imMask,imColor);

[ map,unmappedObjects,missingObjects ] = objectCorrilation( prevColorObjects, currColorObjects );

[ prevColorObjects ] = MapObjects( currColorObjects,map,unmappedObjects,missingObjects );


