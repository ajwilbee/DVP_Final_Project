% connected component labeling
load('MaskImage.mat');
close all
im = workingImage;
%bring mask back down may take this out later after all testing is done
im = im/255;
tester = [0 0 0 0 0 0 0 0; ...
          0 0 0 1 0 0 0 0; ...
          0 0 0 1 0 1 1 1; ...
          0 1 1 1 0 0 0 1; ...
          0 1 0 0 0 1 1 1; ...
          0 0 0 0 0 0 0 0];
se = strel('line',4,0);
imclosed = imclose(~im,se);
figure(1)
imshow(~imclosed*255);
figure(2)
imshow(im*255);

% iterate row first then column
labelcounter = 1;
labeled = zeros(4,1); % bool for if label has been applied

%maybe can implement a map size guess based on previouse frames ?
map = cell(10,1);
mapcount = 1;

% tester = padarray(tester,[1,1],'both');
tester = imclosed;
cm = zeros(size(tester));% component map
for y = 2: size(tester,2)-1
    for x = 2: size(tester,1)-1
        needMap = 0;
%         cm(x,y) = 1;
        labeled = zeros(4,1);
        if(tester(x,y) == 1)
        
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
            
            if(labeled == zeros(4,1))
                cm(x,y) = labelcounter;
                labelcounter = labelcounter+1;
            end
            
            if(needMap > 1)
                temp = labeled(labeled~=0);
                if( length(temp) == 1)
                   disp('1'); 
                end
                map{mapcount} = labeled(labeled~=0);
                mapcount = mapcount +1;
            end

        end
            
           
    end
end
map = map(~cellfun('isempty',map));
for x = 1: length(map)
   
   cm(cm == map{x}(2)) = map{x}(1);
end



