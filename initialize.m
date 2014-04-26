function [ imGMM ] = initialize( im ,Sigma, priorWeight,K)
%UNTITLED2 initializes a pixel with its Gaussian mixture model
% im = image 
%   Detailed explanation goes here
imGMM = cell(size(im,1),size(im,2));
   for row = 1:size(im,1)
       for col = 1:size(im,2)
            mu = permute(im(row,col,:),[3 2 1]);

            GM = struct('mu',mu,'sigma',Sigma,'priorWeight',priorWeight,'match',0);
            GMM = cell(K,1);
            for x = 1:K
                GMM{x} = GM;
            end
            
           GMM =  SortByWeight( GMM );
            imGMM{row,col} = GMM;
       end
   end
   
end

