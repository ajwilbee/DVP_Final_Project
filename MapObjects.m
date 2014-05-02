function [ transitionholder,groupingsHolder,colorMapHolder ] = MapObjects( currColorObjects,currgroupings,map,unmappedObjects,missingObjects,colorMap,initialize )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% create a cell that is large enough for all of the object
% : mapped objects, new objects, and objects that have left
numberOfObjects = length(map)+length(unmappedObjects)+length(missingObjects);
transitionholder = cell(numberOfObjects,1);
colorMapHolder = {[]};
groupingsHolder = cell(numberOfObjects,1);
%% here is where the bounding box and counting will be created and updated
% order the objects according to the apropriot mapping
% put the new objects in at the end
% at the end remove the cells that corrispond to the missing objects
% when i get the bounding box and number counter working they will but
% updated in the same manner so that the colors and numbers remain constant
% may want to consider making a structure
for x = 1:length(map)
   
    transitionholder{map{x}(1)} = currColorObjects{map{x}(2)}; 
    groupingsHolder{map{x}(1)} = currgroupings{map{x}(2)};
    
    
end
counter  = 1;
% go to the end and add the extra objects
if(length(map)+length(missingObjects)<numberOfObjects)
    for x = length(map)+length(missingObjects):numberOfObjects
        transitionholder{x} = currColorObjects{unmappedObjects(counter)};
        groupingsHolder{x} = currgroupings{unmappedObjects(counter)};
        counter = counter + 1;
        % new object gets a new color
        colorMapHolder{x} = [uint8(rand()*255),uint8(rand()*255),uint8(rand()*255)];
    end
end
% remove the missing objects from the display
transitionholder(missingObjects) = [];
groupingsHolder(missingObjects) = [];
colorMapHolder(missingObjects) = [];

%for the first run only this will assign every initial object a color for
%its bounding box
    if(initialize)
        for x = 1:length(transitionholder)
            colorMapHolder{x} = [uint8(rand()*255),uint8(rand()*255),uint8(rand()*255)];
        end
        
    end


end

