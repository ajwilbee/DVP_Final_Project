function [ imGMM,foregroundimage, meanimage, mask ] = update( im , imGMM,K,alpha,T,Sigma,priorWeight)
%update for the next frame check all of the pixels again against their
%gaussians and find the matches and update.
% T is the weight threshold indicating the ammount of information that the
% background must hold.
%   Detailed explanation goes here
foregroundimage = im;
meanimage = zeros(size(im));
mask = ones(size(im,1),size(im,2));
for row = 1:size(im,1)
    for col = 1:size(im,2)
        GMM = imGMM{row,col};
        match = 0;
        goodness = zeros(K,1);
         newmu = permute(im(row,col,:),[3 2 1]);
        for x = 1:K

            mumax = GMM{x}.mu+2.5*diag(GMM{x}.sigma);
            mumin = GMM{x}.mu-2.5*diag(GMM{x}.sigma);
            temp1 = (newmu > mumin);  
            temp2 = newmu < mumax;

            if temp1 
                if temp2;
                    match = 1;
                     goodness(x) = sum(abs((GMM{x}.mu-newmu)./diag(GMM{x}.sigma)).^2).^.5;
                end
            end

        end

        % mark the matching distribution
        % update sigma and mu
        % how calculate roe
          bestmatchindex  = 0;
        if(match)
            % update sigma and mu
            bestmatchindex = find(goodness == max(goodness),1);
            GMM{bestmatchindex}.match = 1;
            denom = (2*pi)^(3/2)*det(GMM{bestmatchindex}.sigma).^(1/2);
            temp = permute(im(1,1,:),[3 2 1])-GMM{bestmatchindex}.mu;
            exponent = -.5*(temp'*double(inv(GMM{bestmatchindex}.sigma))*temp);
            roe = 1./denom*exp(exponent);
            GMM{bestmatchindex}.mu = (1-roe)*GMM{bestmatchindex}.mu+roe*newmu;
            variance  = (1-roe)*GMM{bestmatchindex}.sigma+roe*(newmu-GMM{bestmatchindex}.mu)'*(newmu-GMM{bestmatchindex}.mu);% not so sure about this tuner...
            GMM{bestmatchindex}.sigma = variance;
            % weight update
            for x = 1:K
                if x == bestmatchindex
                 GMM{x}.priorWeight = ((1-alpha)* GMM{x}.priorWeight ...
                                                   + (alpha)*GMM{x}.match);
                else
                    GMM{x}.priorWeight = ((1-alpha)* GMM{x}.priorWeight);
                end
             GMM{x}.match = 0;                              
            end
            GMM =  SortByWeight(GMM);
        else
            % there is no match so eliminate the lowest gaussian and replace with a
            % new one centered around newmu. big sigma low weight aka low
            % confidence
            GMM =  SortByWeight(GMM);   
            GMM{end} = struct('mu',newmu,'sigma',Sigma,'priorWeight',priorWeight,'match',0);
        end
        imGMM{row,col} = GMM;
        meanimage(row,col,:) = GMM{1}.mu;
%         counter = 1;
%         csum = 0;
%         while (csum < T)
%            csum = csum + GMM{ counter}.priorWeight; 
%            counter = counter +1;
%         end
        %check which dist are background and if the picel is in that
        %distribution eliminate it.
        for z = 1:2
           if(permute(im(row,col,:),[3 2 1])<(GMM{z}.mu+2.5*GMM{z}.sigma(1,1)) )
               if (permute(im(row,col,:),[3 2 1])>(GMM{z}.mu-2.5*GMM{z}.sigma(1,1)))
                    foregroundimage(row,col,:) = [0 0 0];%zeros(size(im,3));
                   mask(row,col) = 0;
               end
           end
        end
    end
end

end

