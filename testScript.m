close all
clear all
load('MaskImage.mat');
im = workingImage;
%bring mask back down may take this out later after all testing is done
BW = im/255;

[H,theta,rho] = hough(BW);
figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
        'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot)
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
figure, imshow(im), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');



% [cm,finalmap] = Grouping(im);
% imshow(cm)
% 
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