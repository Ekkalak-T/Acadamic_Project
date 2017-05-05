function [ fg ] = removeShadow( bg,image,fg )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %bgI = rgb2gray(bg);
    %imageI = rgb2gray(image);
    
    length = size(image);
    for row=1:length(1)
        for col=1:length(2)
            if fg(row,col)==1
                rB = bg(row,col,1);
                gB = bg(row,col,2);
                bB = bg(row,col,3);
                rC = image(row,col,1);
                gC = image(row,col,2);
                bC = image(row,col,3);
                sumB = rB+gB+bB;
                sumC = rC+gC+bC;
                %Tlow for prevent misclassify a dark object be shadow
                %Thigh decrease a false positive that misclassify a
                %moving object is shadow
                Tlow = 0.05;
                Thigh = 0.7;
                ratio = (sumB-sumC);

                if ratio > Tlow && ratio < Thigh
                    fg(row,col)=0;
                    %image(row,col,:) = bg(row,col,:);
                end
            end
            %{
            x = bgI(row,col)*imageI(row,col);
            y = abs(bgI(row,col))*abs(imageI(row,col));
            
            tetra = acos(x/y);
            ThresTetra = ;
            if tetra < ThresTetra
                fg(row,col)=0;
            end
            %}
            
            
            %if fg(row,col)==1
             %   image(row,col,:) = bg(row,col,:);
        end
    end
                

end

