function [map,unmappedObjects,missingObjects] = objectCorrilation( prevColorObjects, currColorObjects )
%UNTITLED Summary of this function goes here
%   -takess in a list of all of the objects from two consecutive frames and
%   maps the objects to eachother
%   -any objects which do not appear in the previous frame are returned in
%   the unmapped objects list
%   - the objects are considered to be numbered based on their ordering
%   when enterint the function
%   - missing objects are the objects which previously existed and no
%   longer have a proper corrilation. This is currently set to a less than
%   60% corrilation and will have to be tuned

minCorrilation = .6; % min corrilation in percent
corrilations = cell(length(prevColorObjects),length(currColorObjects),3);
map = cell(length(prevColorObjects),1);
unmappedObjects = 1:1:length(currColorObjects);
missingObjects = 1:1:length(prevColorObjects);
for x = 1:length(prevColorObjects)
    temp = prevColorObjects{x};
    matchingLikelyhood = zeros(length(currColorObjects),1);
    for y = 1: length(currColorObjects)
      
%         figure(1),imshow(temp)
        other = currColorObjects{y};
%         figure(2), imshow(other)
        cumulativeCorrilation = 0;
        for dim = 1: 3
            tempMaxX = size(temp,1);
            tempMaxY = size(temp,2);
            if size(temp,1) > size(other,1)
               tempMaxX = size(other,1);
                
            end
            if size(temp,2) > size(other,2)
               
                tempMaxY = size(other,2);

            end
            
            corrilations{x,y,dim} =  normxcorr2(temp(1: tempMaxX,1: tempMaxY,dim),currColorObjects{y}(:,:,dim));
            % will not be the same location  each time, may need to force
            % it if things break look here
            % key Word Broken
            cumulativeCorrilation = cumulativeCorrilation + max(max(corrilations{x,y,dim}));
        end
        matchingLikelyhood(y) = cumulativeCorrilation;
    end
    if(max(matchingLikelyhood) > 3*minCorrilation)
        mappingIndex = find(matchingLikelyhood == max(matchingLikelyhood));
        unmappedObjects(unmappedObjects == mappingIndex) = []; 
        missingObjects(missingObjects == x) = [];
        map{x} = [x mappingIndex];
    end
end

end

