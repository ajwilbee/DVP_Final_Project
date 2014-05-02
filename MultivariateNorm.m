% now get it ready to itterate over the whole movie
Vread = VideoReader('No_Mirror.mp4');

    nFrames = Vread.NumberOfFrames;
    vidHeight = Vread.Height;
    vidWidth = Vread.Width;
    mov(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
               'colormap',[]); 
    mov2(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
       'colormap',[]); 
   
    mov3(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
       'colormap',[]); 

im1 = read(Vread,1);
% im1 = rgb2gray(im1);
im1 = double(im1(12:end-12,24:end-20,:));


% how do i set the variance so that the probability does not explode.
Sigma = eye(size(im1,3))*13;
priorWeight = .01;
K = 3;
alpha = 1/40;

[ imGMM ] = initialize( im1 ,Sigma, priorWeight,K);
T = .5;
% 
for k = 1 : nFrames-1
        im = read(Vread,k);
%         im = rgb2gray(im);
        im = double(im(12:end-12,24:end-20,:));
        
        [ imGMM,imout,muim,mask ] = update( im , imGMM,K,alpha,T,Sigma, priorWeight);
        figure(2)
        imshow(uint8(imout));
        figure(3)
        imshow(uint8(muim));
        figure(4)
        imshow(uint8(mask*255));
        %mask = cat(3,mask,mask,mask);
        mov(k).cdata = uint8(imout);
        mov2(k).cdata = uint8(muim);
        mov3(k).cdata = uint8(mask);
end
temp = Vread.FrameRate;
movie(mov,1,temp);
movie(mov2,1,temp);
save('No_Mirror','mov','mov2','mov3','Sigma','alpha','temp');
%movie(mov3,1,temp);
% 
% k = 40;
% im = read(Vread,k);
%         im = double(im(12:end-12,24:end-20,:));
%         [ imGMM,imout ] = update( im , imGMM,K,alpha,T,Sigma, priorWeight);
%         figure(2)
%         imshow(uint8(imout));
%         mov(k).cdata = uint8(imout);

    





