function [ boxedImage ] = DrawBoundingBox( boxedImage, objectMask,boxColor )
%DrawBoundingBox draws a bounding box around an object of interrest
% -boxedImage is the original image that is being modified to include the
% bounding boxes, must be a color image
% -ObjectMask is the binary image with only the object of interrest
% displayed
% -boxColor is the color the bounding box is to be drawn in

BB = regionprops(objectMask,'BoundingBox');
BB = round(BB.BoundingBox);
%BB(1:2) = BB(1:2)+1;
BB(3:4) = BB(3:4) -2;
boxedImage(BB(2),BB(1):BB(1)+BB(3),1) = boxColor(1);
boxedImage(BB(2),BB(1):BB(1)+BB(3),2) = boxColor(2);
boxedImage(BB(2),BB(1):BB(1)+BB(3),3) = boxColor(3);

boxedImage(BB(2)+BB(4),BB(1):BB(1)+BB(3),1) = boxColor(1);
boxedImage(BB(2)+BB(4),BB(1):BB(1)+BB(3),2) = boxColor(2);
boxedImage(BB(2)+BB(4),BB(1):BB(1)+BB(3),3) = boxColor(3);

boxedImage(BB(2):BB(2)+BB(4),BB(1),1) = boxColor(1);
boxedImage(BB(2):BB(2)+BB(4),BB(1),2) = boxColor(2);
boxedImage(BB(2):BB(2)+BB(4),BB(1),3) = boxColor(3);

boxedImage(BB(2):BB(2)+BB(4),BB(1)+BB(3),1) = boxColor(1);
boxedImage(BB(2):BB(2)+BB(4),BB(1)+BB(3),2) = boxColor(2);
boxedImage(BB(2):BB(2)+BB(4),BB(1)+BB(3),3) = boxColor(3);
end

