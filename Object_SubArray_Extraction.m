function [colorObjects,groupings] = Object_SubArray_Extraction(mask,colorMask,Threshold,strelDiameter)

% takes in a color foreground image and the forground mask and finds the
% image sub arrays and returns them to be used as cross corrilation filters
% for object tracking

%Threshold will say what is an unreasonably small size for the object

[grouped, map]= Grouping(mask,strelDiameter);

groupings = cell(length(map),1);
colorObjects = cell(length(map),1);
cellremovelist = [];
cellRcounter = 1;

finalrow = 0;
finalcol = 0;
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
            newBoxDimention = mean(rowLengths)-1;
            % make all the rows the same length
            removelist = 0;
            counter = 1;
            for row = 1:size(temp,1)
                
                if(length(test{row}) >= newBoxDimention)
                    l = length(test{row});
                    offset = ceil((l-newBoxDimention)/2);
                    if(offset > 0)
                        test{row} = test{row}(offset:offset+newBoxDimention-1);
                    end
                else
                    removelist(counter) = row;
                    counter = counter +1;
                end
                
            end
            test(removelist) = [];
            temp = cell2mat(test);
            %temp = impyramid(temp,'reduce'); % make it so that scale is not an issue

            
            %force all color plane dimentions to be the same size
            if dim == 1
                [finalrow, finalcol] = size(temp);
                
            else
                
                if size(temp,1) < finalrow
                    increaseby = finalrow - size(temp,1);
                    
                    for q = 1:increaseby
                        tempvec = temp(end,:);
                        temp = cat(1,temp,tempvec);
                    end
                end
                if size(temp,1) > finalrow
                   decreaseby = size(temp,1) - finalrow;
                    temp = temp(1:end-decreaseby,:);
                    
                end
                
                if size(temp,2) < finalcol
                    increaseby = finalcol - size(temp,2);
                    for q = 1:increaseby
                        tempvec = temp(:,end);
                        temp = cat(2,temp,tempvec);
                    end
                end
                if size(temp,2) > finalcol
                    decreaseby = size(temp,2) - finalcol;
                    temp = temp(:,1:end-decreaseby);
                end
                
            end
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
  

