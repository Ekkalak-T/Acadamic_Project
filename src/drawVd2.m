
function [ image_out ] = drawVd2(row, column, image, shape, color)
%UNTITLED2  of this function goes here
%   Detailed explanation goes here
    walk = 0; 
    st_row = row(1);
    end_row = row(2);
    count_row = 0;
    st_col = column(1);
    end_col = column(2);
    
    for r = st_row:end_row
        % header and bottom must paint all column 
        if r == st_row || r == end_row
                for c = (st_col-walk:end_col+walk)
                    image = paintVd(r,c,image,color);
                end
        else
        %other row must paint only first and last column
            if mod(count_row,shape) == 0
                walk = walk+1;
                image = paintVd(r,st_col-walk,image,color);
                image = paintVd(r,end_col+walk,image,color);
            else
                image = paintVd(r,st_col-walk,image,color);
                image = paintVd(r,end_col+walk,image,color);
            end
            
        end
        count_row=count_row+1;
        
    end
    image_out = image;
    end