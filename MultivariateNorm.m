function [mov,mov2,mov3,mov4,Sigma,alpha,temp] = MultivariateNorm(filename, extention)
% takes in a file name and an extention (.mp4,.wmv) and will perform
% background subtraction on the whole movie, it takes a very long time
% hence the project is performed in two steps.
% the program will save the relavent infromation to a file which will be
% needed by the second part of the projects function. the values stored
% are:
%
% Input:
% filename = just the name of the file
% extention = the file extention with the dot included (.wmv)
% output:
% mov = the foreground movie
% mov2 = the background movie
% mov3 = the background foreground mask ( must be multiplied by 255 in
% order to see it when displayed
% mov4 = the original movie sequence
% Sigma = the programs initializing standard deviation
% alpha = the programs learning factor
%
% now get it ready to itterate over the whole movie

%filename = ['Large'];
%extention = ['.wmv'];
fullFile = [filename extention];

Vread = VideoReader(fullFile);

    nFrames = Vread.NumberOfFrames;
    vidHeight = Vread.Height;
    vidWidth = Vread.Width;
    mov(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
               'colormap',[]); 
    mov2(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
       'colormap',[]); 
   
    mov3(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
       'colormap',[]); 
    mov4(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
       'colormap',[]); 

im1 = read(Vread,1);
% im1 = rgb2gray(im1);
im1 = double(im1(12:end-12,24:end-20,:));


% how do i set the variance so that the probability does not explode.
Sigma = eye(size(im1,3))*20; % speed that the confidence increases at
priorWeight = .01;
K = 3;
alpha = 1/60;%speed at which the gaussians update

[ imGMM ] = initialize( im1 ,Sigma, priorWeight,K);
T = .5;
% 
for k = 1 : nFrames-1
        im = read(Vread,k);
%         im = rgb2gray(im);
        im = double(im(12:end-12,24:end-20,:));
        tic
        [ imGMM,imout,muim,mask ] = update( im , imGMM,K,alpha,T,Sigma, priorWeight);
        toc
%         figure(2)
%         imshow(uint8(imout));
%         figure(3)
%         imshow(uint8(muim));
%         figure(4)
%         imshow(uint8(mask*255));
        %mask = cat(3,mask,mask,mask);
        mov(k).cdata = uint8(imout);
        mov2(k).cdata = uint8(muim);
        mov3(k).cdata = uint8(mask);
        mov4(k).cdata = uint8(im);
end
temp = Vread.FrameRate;
movie(mov,1,temp);
movie(mov2,1,temp);
save(filename,'mov','mov2','mov3','mov4','Sigma','alpha','temp');


end    


%movie(mov3,1,temp);
% 
% k = 40;
% im = read(Vread,k);
%         im = double(im(12:end-12,24:end-20,:));
%         [ imGMM,imout ] = update( im , imGMM,K,alpha,T,Sigma, priorWeight);
%         figure(2)
%         imshow(uint8(imout));
%         mov(k).cdata = uint8(imout);




