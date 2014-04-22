
Vread = VideoReader('WB1.mp4');

    nFrames = Vread.NumberOfFrames;
    vidHeight = Vread.Height;
    vidWidth = Vread.Width;
    mov(1:nFrames) = ...
        struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
               'colormap',[]); 

im1 = read(Vread,1);
im1 = im2double(im1);
im2 = read(Vread,2);
           
mu = [im1(1,1,1); im1(1,1,2); im1(1,1,3)];
% how do i set the variance so that the probability does not explode.
Sigma = eye(3)*.01;
priorWeight = .01;
K = 4;
alpha = 1/40;

GM = struct('mu',mu,'sigma',Sigma,'priorWeight',.01,'match',0);
GMM = cell(K,1);
for x = 1:K
    GMM{x} = GM;
end

denom = (2*pi)^(3/2)*det(GMM{1}.sigma.^2).^(1/2);
temp = permute(im1(1,1,:),[3 2 1])-GMM{1}.mu;
temp = double(temp);
exponent = -.5*(temp'*double(inv(GMM{1}.sigma))*temp);

temp = 1./denom*exp(exponent); % this is to large because of the variance

match = 0;
im1 = read(Vread,2);
im1 = im2double(im1);
goodness = zeros(K,1);
 newmu = [im1(1,1,1); im1(1,1,2); im1(1,1,3)];
for x = 1:K
   
    mumax = GMM{x}.mu+2.5*diag(GMM{x}.sigma);
    mumin = GMM{x}.mu-2.5*diag(GMM{x}.sigma);
    temp1 = (newmu > mumin);  
    temp2 = newmu < mumax;
    
    if sum(temp1) == 3 && sum(temp2)==3;
        match = 1;
        goodness(x) = abs((GMM{x}.mu-newmu)/GMM{x}.sigma);
    end
    
end

% mark the matching distribution
% update sigma and mu
% how calculate roe
if(match)
    bestmatchindex = find(goodness == max(goodness),1);
    GMM{bestmatchindex}.match = 1;
    %roe = ???
    GMM{bestmatchindex}.mu = (1-roe)*GMM{bestmatchindex}+roe*newmu;
    variance  = (1-roe)*GMM{bestmatchindex}.sigma.^2+roe(newmu-GMM{bestmatchindex}.mu)'*(newmu-GMM{bestmatchindex}.mu);
    GMM{bestmatchindex}.sigma = variance.^.5;
end
% weight update
for x = 1:K
     GMM{bestmatchindex}.priorWeight = (1-alpha)* GMM{bestmatchindex}.priorWeight ...
                                       + alpha*GMM{bestmatchindex}.match;
     GMM{bestmatchindex}.match = 0;                              
end



