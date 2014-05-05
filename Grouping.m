function [cm,finalmap] = Grouping(im)
% this function will take in a binary logical mask of foreground pixels
% and segment it into its groupings by doing a connected component analysis

% returns the segmented image cm and the segment mapping numbers


% connected component labeling

% tester = [0 0 0 0 0 0 0 0; ...
%           0 0 0 1 0 0 0 0; ...
%           0 0 0 1 0 1 1 1; ...
%           0 1 1 1 0 0 0 1; ...
%           0 1 0 0 0 1 1 1; ...
%           0 0 0 0 0 0 0 0];
se = strel('line',4,0);
imclosed = imclose(~im,se);

% iterate row first then column
labelcounter = 1;
labeled = zeros(4,1); % bool for if label has been applied

%maybe can implement a map size guess based on previouse frames ?
clear map
map{1} = zeros(4,1);
mapcount = 2;
tester = ~imclosed;

tester = padarray(tester,[1,1],'both');
cm = zeros(size(tester));% component map
for y = 2: size(tester,2)-1
    for x = 2: size(tester,1)-1      
        
        needMap = 0;
%         cm(x,y) = 1;
        labeled = zeros(4,1);
        %only label the foreground objects
        if(tester(x,y) == 1)
            %check the surrounding 4 previously searched locations and see
            %if any of them are alreadt labeled, if so the new label is the
            %same as the last on encountered.
            if(cm(x-1,y-1) >0)
                cm(x,y) = cm(x-1,y+1);
                labeled(1) = cm(x-1,y+1);
                needMap = needMap+1;
            end

            if(cm(x,y-1) >0)
                cm(x,y) = cm(x,y-1);
                labeled(2) = cm(x,y-1);
                needMap = needMap+1;
             
            end
            if(cm(x+1,y-1) >0)
                cm(x,y) = cm(x+1,y-1);
                labeled(3) = cm(x+1,y-1);
                needMap = needMap+1;
            end
            if(cm(x-1,y) >0)
                cm(x,y) = cm(x-1,y);
                labeled(4) = cm(x-1,y);
                needMap = needMap+1;
            end
            %no previous point was labeled, thus new label
            if(labeled == zeros(4,1))
                cm(x,y) = labelcounter;
                labelcounter = labelcounter+1;
            end
            % create a map,
            % sort the incomming mappings in a ascending order, this will
            % cause the lowest values to be the only ones left after
            % mapping, however initially the zeros are left in to assure
            % that the vector lengths work.
            % if the preposed map matches a previous map then no new map is
            % made.
            % is a new map occurs it is added
            if(needMap > 1)
                temp = labeled;
                temp = sort(temp,'ascend');
                alreadyMapped = 0;
                
                for q = 1:length(map)
                   if(sum(map{q} == temp) == length(temp))
                       alreadyMapped = 1;
                   end
                end
                if(~alreadyMapped)
                    map{mapcount} = temp;
                    mapcount = mapcount +1;
                end
                
            end

        end
            
           
    end
end
 finalmap = 1:1:(labelcounter-1);
 fmcount = 1;
% go through the map table and convert every pixel to its minimum map
for x = 1: length(map)
    workingMap = map{x};
    diffTest = diff(workingMap);
    workingMap(2:end) = workingMap(2:end).*~(diffTest == 0); 
    workingMap = workingMap(workingMap~=0);
    if(length(workingMap) > 1)
       for y = 1:length(workingMap)-1
            cm(cm == workingMap(y+1)) = workingMap(1);
            % need to fix all of the mappings so dont miss any corrilations
            finalmap(finalmap == workingMap(y+1)) = 0;
            for z = x:length(map)
               map{z}(map{z} ==  workingMap(y+1)) = workingMap(1);
            end
       end
      % finalmap(fmcount) = workingMap(1);
       %fmcount = fmcount+1;
    end
end
    cm = cm(2:end-1,2:end-1);% take away padding
    if(length(finalmap) > 1)
    finalmap =  sort(finalmap,'ascend');
    diffTest = diff(finalmap);
    finalmap(2:end) = finalmap(2:end).*~(diffTest == 0);
    end
    finalmap = finalmap(finalmap~=0);
% segmentIm = uint8(zeros(size(im,1),size(im,2),3));
% for x = 1:length(finalmap)
%    temp = cm==finalmap(x);
%     r = uint8(temp*rand()*255);
%     g = uint8(temp*rand()*255);
%     b = uint8(temp*rand()*255);
%     tempcolor = cat(3,r,g,b);
%     tempcolor = tempcolor(2:end-1,2:end-1,:);
%     segmentIm = segmentIm+tempcolor; %eliminate the padding
%     
% end
% figure
% imshow(segmentIm)


