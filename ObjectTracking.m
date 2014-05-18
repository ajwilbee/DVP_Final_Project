function [movFinal,ObjectCounter] = ObjectTracking(FileName,Threshold,strelDiameter)
% load the movie to be worked on



load([FileName '.mat'])
close all
imMask = mov3(1).cdata;
imColor = mov4(1).cdata;
% Threshold = 150;
% strelDiameter = 3; %2 for small videos
 ObjectCounter = 0;
movFinal(1:length(mov4)-1) = struct('cdata',zeros(256,256,3,'uint8'),...
               'colormap',[]);
[prevColorObjects,prevgroupings] = Object_SubArray_Extraction(imMask,imColor,Threshold,strelDiameter );
[currColorObjects,currgroupings] = Object_SubArray_Extraction(imMask,imColor,Threshold,strelDiameter);


[ map,unmappedObjects,missingObjects ] = objectCorrilation( prevColorObjects, currColorObjects );
initialize = 1;
colorMap = {[]};
[ prevColorObjects,prevgroupings,colorMap,ObjectCounter ] = MapObjects( currColorObjects,currgroupings,map,unmappedObjects,missingObjects,colorMap,initialize,ObjectCounter);

for x = 1:length(prevColorObjects)
   
%    figure(1), imshow(prevColorObjects{x});
%    figure(2), imshow(prevgroupings{x});
    [ imColor ] = DrawBoundingBox( imColor, prevgroupings{x},colorMap{x} );
end
%figure(3), imshow(imColor);
initialize = 0;

for k = 1:length(mov)-1
tic    
    imMask = mov3(k).cdata;
    imColor = mov4(k).cdata;
if k ==5
   disp(62) 
end
    [currColorObjects,currgroupings] = Object_SubArray_Extraction(imMask,imColor,Threshold,strelDiameter);

    
    [ map,unmappedObjects,missingObjects ] = objectCorrilation( prevColorObjects, currColorObjects );
    [ prevColorObjects,prevgroupings,colorMap,ObjectCounter ] = MapObjects( currColorObjects,currgroupings,map,unmappedObjects,missingObjects,colorMap,initialize,ObjectCounter);
    for x = 1:length(prevColorObjects)
   
   % figure(4), imshow(prevColorObjects{x});
   % figure(5), imshow(prevgroupings{x});
    [ imColor ] = DrawBoundingBox( imColor, prevgroupings{x},colorMap{x} );

    end
    %figure(6),
        %imshow(imColor);
    imColor = imresize(imColor,[256,256]);

    movFinal(k).cdata = uint8(imColor);
    toc
end

save([FileName 'Final'],'mov','mov2','mov3','mov4','movFinal','Sigma','alpha','temp','ObjectCounter');

end
