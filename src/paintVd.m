function [ image_out ] = paintVd( r, c, image, colour)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if strcmp(colour,'red')
        image(r,c,1) = 255;
        image(r,c,2) = 0;
        image(r,c,3) = 0;
    else if strcmp(colour,'white')
            image(r,c,:) = 255;
        end
    end
    image_out = image;
end

