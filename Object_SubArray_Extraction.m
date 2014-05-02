function [colorObjects] = Object_SubArray_Extraction(mask,colorMask)

% takes in a color foreground image and the forground mask and finds the
% image sub arrays and returns them to be used as cross corrilation filters
% for object tracking

[grouped, map]= Grouping(mask);

groupings = cell(length(map),1);
colorObjects = cell(length(map),1);
cellremovelist = 0;
cellRcounter = 1;
Threshold = 15;
for x = 1: length(map)
   
    % get a particular object
    groupings{x} = grouped == map(x);
    % check to see if it is obviously noise or somthing we dont care about
    if( sum(sum(groupings{x}))<Threshold) % may eventually want to usesome gaussian somthing... now just kill anything less than 15 pixel

        cellremovelist(cellRcounter) = x;
        cellRcounter = cellRcounter+1;
    else
        colorimage = cell(3,1);
        for dim = 1:3
            % for each color layer extract out the subarray of only the
            % object
            temp = colorMask(:,:,dim).*uint8(groupings{x});
            test = cell(size(temp,1),1);
            rowLengths = zeros(size(temp,1),1);
            for row = 1:size(temp,1)
                
                test{row} = temp(row,:);
                test{row}(test{row} == 0) = [];
                rowLengths(row) = length(test{row});
            end
            rowLengths(rowLengths == 0) = [];
            newBoxDimention = mean(rowLengths);
            % make all the rows the same length
            removelist = 0;
            counter = 1;
            for row = 1:size(temp,1)
                
                if(length(test{row}) >= newBoxDimention)
                    l = length(test{row});
                    offset = floor((l-newBoxDimention)/2);
                    test{row} = test{row}(offset:offset+newBoxDimention);
                else
                    removelist(counter) = row;
                    counter = counter +1;
                end
                
            end
            test(removelist) = [];
            temp = cell2mat(test);
            %temp = impyramid(temp,'reduce'); % make it so that scale is not an issue
            colorimage{dim} = temp;
%             colorimage
%             
        end
        
        CI = cat(3,colorimage{1},colorimage{2},colorimage{3});
        colorObjects{x} = CI;
%         figure, imshow(CI);
    end

end
    colorObjects(cellremovelist) = [];
    groupings(cellremovelist) = [];
    
end
  

