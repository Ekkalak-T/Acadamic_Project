function [ has_car ] = virtualDetect2(row, column, ch, shape)
%UNTITLED2  of this function goes here
%   Detailed explanation goes here
        w_detected = 0;
        b_detected = 0;    
        walk = 0;
        count_row = 0;
        for r = row(1):row(2)
           if mod(count_row,shape) == 0
                walk = walk+1;
                st_col = column(1)-walk;
                end_col = column(2)+walk;
           else
                st_col = column(1)-walk;
                end_col = column(2)+walk;
            end
            for c = st_col:end_col
               if ch(r,c) == 1
                   w_detected =  w_detected + 1;
               else
                   b_detected = b_detected + 1;
               end
            end
            count_row=count_row+1;
        end
        
        
        
        
        w_ratio = w_detected/(w_detected + b_detected);
        if w_ratio >= 0.5
            has_car = true;
        else
            has_car = false;
        end
    end