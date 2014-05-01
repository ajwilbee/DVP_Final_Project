function [ GMMByWeight ] = SortByWeight( GMM )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

weights = zeros(size(GMM));

for x = 1:length(GMM)
   weights(x) = GMM{x}.priorWeight;
end
[sorted, index] = sort(weights/GMM{x}.sigma(1,1),'descend');
normalizer = sum(weights);
GMMByWeight = cell(size(GMM));
for x = 1:length(GMM)
    GMM{index(x)}.priorWeight=GMM{index(x)}.priorWeight/normalizer;
    GMMByWeight{x} = GMM{index(x)};
end

end

