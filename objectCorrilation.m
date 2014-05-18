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
matchingLikelyhood = zeros(length(prevColorObjects),length(currColorObjects));

for x = 1:length(prevColorObjects)
    temp = prevColorObjects{x};
   
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
            
           if(~range(temp(1: tempMaxX,1: tempMaxY,dim)))
              temp(1,1) = temp(1,1)+1; 
           end
            corrilations{x,y,dim} =  normxcorr2(temp(1: tempMaxX,1: tempMaxY,dim),currColorObjects{y}(:,:,dim));
            
            % will not be the same location  each time, may need to force
            % it if things break look here
            % key Word Broken
            cumulativeCorrilation = cumulativeCorrilation + norm(corrilations{x,y,dim}); %max(max(corrilations{x,y,dim}))
        end
        matchingLikelyhood(x,y) = cumulativeCorrilation;
        
    end
    
    
end
% a corrilation weight matrix was created, rows are past objects colums are
% current objects,

% not sure if this method will give the correct mapping
if length(prevColorObjects) > length(currColorObjects)
     % highest weight in a column is the corrilating object,
     % winning row is set to zero to preserve counting integrity
     % so backwards from the other case
    for x = 1:length(currColorObjects)
        mappingIndex = find(matchingLikelyhood(:,x) == max(matchingLikelyhood(:,x)));
        unmappedObjects(unmappedObjects == x) = []; 
        missingObjects(missingObjects == mappingIndex) = [];
        matchingLikelyhood(mappingIndex,:) = zeros(1,size(matchingLikelyhood,2));
        map{x} = [mappingIndex x ];
    end

else 
     % highest weight in a row is the corrilating object,
     % winning column is set to zero to preserve counting integrity
        for x = 1:length(prevColorObjects)
            mappingIndex = find(matchingLikelyhood(x,:) == max(matchingLikelyhood(x,:)));
            unmappedObjects(unmappedObjects == mappingIndex) = []; 
            missingObjects(missingObjects == x) = [];
            matchingLikelyhood(:,mappingIndex) = zeros(size(matchingLikelyhood,1),1);
            map{x} = [x mappingIndex ];
        end
end


map(cellfun(@isempty,map)) = [];

% if(max(matchingLikelyhood) > 3*minCorrilation)
%         mappingIndex = find(matchingLikelyhood == max(matchingLikelyhood));
%         unmappedObjects(unmappedObjects == mappingIndex) = []; 
%         missingObjects(missingObjects == x) = [];
%         map{x} = [x mappingIndex max(matchingLikelyhood)];
%     end
% check to ensure  no empty maps
% map(cellfun(@isempty,map)) = [];

%to ensure a strictly one to one relationship
% for each current object find all of the previous objects it maps to if
% there are more than one, find the strongest match and eliminate all others
% for each eliminated match that is an object that is now missing in the
% subsiquent frame and as such should be put on the missing object list
% sort the list at the end
% for x = 1:length(currColorObjects)
%     counter = 1;
%     doubleMappedWeight = [];
%     doubleMapped = [];
%    for y = 1:length(map)
%        if(map{y}(2) == x)
%             doubleMappedWeight(counter) = map{y}(3);
%             doubleMapped(counter) = y;
%             counter = counter +1;
%        end
%    end
%    % find best match, take it off the list and remove all mapings that are
%    % still on the list, then put those mappings on the missing object list
%     bestMatch = find(doubleMappedWeight == max(doubleMappedWeight));
%     doubleMapped(bestMatch) = [];
%     map(doubleMapped) = [];
%     for y = 1:length(doubleMapped)
%        missingObjects(end+1) = doubleMapped(y); 
%     end
% end
% sort the missing object list from 0-infinity
% sort(missingObjects,'ascend');
end

