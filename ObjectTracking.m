
% load the movie to be worked on
load('dissolve.mat')
close all
imMask = mov3(1).cdata;
imColor = mov(1).cdata;
[prevColorObjects,prevgroupings] = Object_SubArray_Extraction(imMask,imColor);
[currColorObjects,currgroupings] = Object_SubArray_Extraction(imMask,imColor);


[ map,unmappedObjects,missingObjects ] = objectCorrilation( prevColorObjects, currColorObjects );
initialize = 1;
colorMap = {[]};
[ prevColorObjects,prevgroupings,colorMap ] = MapObjects( currColorObjects,currgroupings,map,unmappedObjects,missingObjects,colorMap,initialize);

for x = 1:length(prevColorObjects)
   
%     figure(1), imshow(prevColorObjects{x});
%     figure(2), imshow(prevgroupings{x});
    [ imColor ] = DrawBoundingBox( imColor, prevgroupings{x},colorMap{x} );
end
% figure(3), imshow(imColor);
initialize = 0;
for k = 1:length(mov)-1
    
    imMask = mov3(k).cdata;
    imColor = mov(k).cdata;
if k ==28
   disp(62) 
end
    [currColorObjects,currgroupings] = Object_SubArray_Extraction(imMask,imColor);

    
    [ map,unmappedObjects,missingObjects ] = objectCorrilation( prevColorObjects, currColorObjects );
    [ prevColorObjects,prevgroupings,colorMap ] = MapObjects( currColorObjects,currgroupings,map,unmappedObjects,missingObjects,colorMap,initialize);
    for x = 1:length(prevColorObjects)
   
%     figure(4), imshow(prevColorObjects{x});
%     figure(5), imshow(prevgroupings{x});
    [ imColor ] = DrawBoundingBox( imColor, prevgroupings{x},colorMap{x} );
    figure(6)
    imshow(imColor);
    end
end

