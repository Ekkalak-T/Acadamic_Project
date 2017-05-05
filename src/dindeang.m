

%hbfr = vision.BinaryFileReader('Filename', 'viptraffic.bin');


filename = 'dindaeng.avi';
% Initialize (construct) the System object to read your AVI file.
hvfr = vision.VideoFileReader(filename, ...
                              'ImageColorSpace', 'RGB');
                          
finfo = info(hvfr);
frame_rate = finfo.VideoFrameRate;



hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');

hof = vision.ForegroundDetector(...
        'NumTrainingFrames', 30*60*60, ...     % only 5 because of short video
        'InitialVariance', (30/255)^2 , ...  % initial standard deviation of 30/255
        'MinimumBackgroundRatio', 0.4);
                
hshapeins1 = vision.ShapeInserter( ...
            'BorderColor', 'Custom', ...
            'CustomBorderColor', [0 255 0]);
vdetect = vision.ShapeInserter( ...
            'BorderColor', 'Custom', ...
            'CustomBorderColor', [255 0 0]);

hshapeins2 = vision.ShapeInserter( ...
            'Shape','Lines', ...
            'BorderColor', 'Custom', ...
            'CustomBorderColor', [255 255 0]);
%Create and configure a System object to write the number of cars being tracked.

lane1 = vision.TextInserter( ...
        'Text', '%4d', ...
        'Location',  [0 0], ...
        'Color', [255 255 255], ...
        'FontSize', 12);
lane2 = vision.TextInserter( ...
        'Text', '%4d', ...
        'Location',  [0 20], ...
        'Color', [255 255 255], ...
        'FontSize', 12);
 lane3 = vision.TextInserter( ...
        'Text', '%4d', ...
        'Location',  [0 40], ...
        'Color', [255 255 255], ...
        'FontSize', 12);

 lane4 = vision.TextInserter( ...
        'Text', '%4d', ...
        'Location',  [0 60], ...
        'Color', [255 255 255], ...
        'FontSize', 12);    
all_lane = vision.TextInserter( ...
        'Text', '%4d', ...
        'Location',  [0 290], ...
        'Color', [255 255 255], ...
        'FontSize', 12);
    
    %%{
sz = get(0,'ScreenSize');
pos = [20 sz(4)-420 325 325];
hVideoOrig = vision.VideoPlayer('Name', 'Original', 'Position', pos);
pos(1) = pos(1)+350; % move the next viewer to the right
hVideoFg = vision.VideoPlayer('Name', 'Foreground', 'Position', pos);
pos(1) = pos(1)+350;

hVideosh = vision.VideoPlayer('Name', 'ShadowRemoval', 'Position', pos);
pos(1) = pos(1)+350;    

hVideoFgd = vision.VideoPlayer('Name', 'Dilation', 'Position', pos);
pos = [-100 sz(4) 325 325];

hVideoFgf = vision.VideoPlayer('Name', 'Fill', 'Position', pos);

pos(1) = pos(1)+330;
hVideoRes = vision.VideoPlayer('Name', 'Results', 'Position', pos);

hclose = vision.MorphologicalClose('Neighborhood', strel('line',5,45));
herode = vision.MorphologicalErode('Neighborhood', strel('square',1));

%}
line_row = 22; % Define region of interest (ROI)



                
%In main loop read one frame at a time from the .avi file as an RGB image, 
%and convert that to an intensity image for further processing.
Framer = 0;
count_car = 0;

index_row = 0;

before_Frame1 = 0;
before_Frame2 = 0;
before_Frame3 = 0;
before_Frame4 = 0;




int_index = 1;
int_change = false;


period_time1 = [];
period_time2 = [];
period_time3 = [];
period_time4 = [];

TS1 = [];
TS2 = [];
TS3 = [];
TS4 = [];
TSAll = [];



has_car1 = false;
has_car2 = false;
has_car3 = false;
has_car4 = false;


car1 = 0;
car2 = 0;
car3 = 0;
car4 = 0;


old_car1 = 0;
old_car2 = 0;
old_car3 = 0;
old_car4 = 0;

d_lane1 = [136,152;40,65];
d_lane2 = [136,152;76,113];
d_lane3 = [136,152;126,163];
d_lane4 = [136,152;181,210];


while ~isDone(hvfr)

                                                              
     % image is one frame in RGB, now call the step() method of ColorSpaceConverter
    % to convert each RGB frame to an intensity image for further processing                                       
    image = step(hvfr);     
    res = size(image);
    
    y = step(hcsc, image);

    %y = rgb2gray(image);
    
    % Remove the effect of sudden intensity changes due to camera's
    % auto white balancing algorithm.
    mean_int = mean(y(:));
 
    y = y-mean_int;
    
    fg_image = step(hof, y); % Foreground
    fg_image2 = removeShadow(bg,image,fg_image);

    Framer = Framer+1;

    if mod(Framer,30*60) == 0
        disp(Framer/1800)
    end
    
    if mod(Framer,30)==0
        %disp(Framer/30)
        TS1(length(TS1)+1) = car1;
        TS2(length(TS2)+1) = car2;
        TS3(length(TS3)+1) = car3;
        TS4(length(TS4)+1) = car4;
        TSAll(length(TSAll)+1) = count_car;
    end
    
    %int_index = int_index+1;

    sq = ones(6,4);
    fg_bw_dil = imdilate(fg_image2,sq);
    ch = imfill(fg_bw_dil,'holes');
    
    now_car = int32(count_car);
    y2 = image;
    y2 = drawVd2(d_lane1(1,:),d_lane1(2,:),y2,8,'red');
    y2 = drawVd2(d_lane2(1,:),d_lane2(2,:),y2,8,'red');
    y2 = drawVd2(d_lane3(1,:),d_lane3(2,:),y2,6,'red');
    y2 = drawVd2(d_lane4(1,:),d_lane4(2,:),y2,6,'red');
    
    y2(1:15,1:320,:) = 0;
    
        Vd1 = virtualDetect2(d_lane1(1,:),d_lane1(2,:),ch,8);
        Vd2 = virtualDetect2(d_lane2(1,:),d_lane2(2,:),ch,8);
        Vd3 = virtualDetect2(d_lane3(1,:),d_lane3(2,:),ch,6);
        Vd4 = virtualDetect2(d_lane4(1,:),d_lane4(2,:),ch,6);
        
        if  Vd1 == true && has_car1 == false
        count_car = count_car + 1;
        car1 = car1+1;
        has_car1 = true;
        elseif Vd1 == false
            has_car1 = false;
        end   

        if  Vd2 == true  && has_car2 == false
            count_car = count_car + 1;
            car2 = car2+1;
            has_car2 = true;
        elseif Vd2 == false
            has_car2 = false;
        end
        if  Vd3 == true && has_car3 == false
            count_car = count_car + 1;
            car3 = car3+1;
            has_car3 = true;
        elseif Vd3 == false
            has_car3 = false;
        end
        if  Vd4 == true && has_car4 == false
            count_car = count_car + 1;
            car4 = car4+1;
            has_car4 = true;
        elseif Vd4 == false
            has_car4 = false;
        end


        
        
     if has_car1 
         y2 = drawVd2(d_lane1(1,:),d_lane1(2,:),y2,8,'white');
     end
     if has_car2
         y2 = drawVd2(d_lane2(1,:),d_lane2(2,:),y2,8,'white');
     end
    if has_car3
         y2 = drawVd2(d_lane3(1,:),d_lane3(2,:),y2,6,'white');
    end
    if has_car4
         y2 = drawVd2(d_lane4(1,:),d_lane4(2,:),y2,6,'white');
    end    
    
    % Keep period of a car by car into the line 
    % Caculate time difference when number of car is increasing
    if old_car1 ~= car1
        diff_frame = Framer-before_Frame1;
        diff_time = diff_frame/frame_rate;       
        period_time1(length(period_time1)+1) = diff_time;
        old_car1 = car1;
        before_Frame1 = Framer;
    end
    if old_car2 ~= car2
        diff_frame = Framer-before_Frame2;
        diff_time = diff_frame/frame_rate;       
        period_time2(length(period_time2)+1) = diff_time;
        old_car2 = car2;
        before_Frame2 = Framer;
    end
    if old_car3 ~= car3
        diff_frame = Framer-before_Frame3;
        diff_time = diff_frame/frame_rate;       
        period_time3(length(period_time3)+1) = diff_time;
        old_car3 = car3;
        before_Frame3 = Framer;
    end
    if old_car4 ~= car4
        diff_frame = Framer-before_Frame4;
        diff_time = diff_frame/frame_rate;       
        period_time4(length(period_time4)+1) = diff_time;
        old_car4 = car4;
        before_Frame4 = Framer;
    end
    
    
    
    
    image_out = step(lane1, y2, int32(car1));
    image_out = step(lane2, image_out, int32(car2));
    image_out = step(lane3, image_out, int32(car3));
    image_out = step(lane4, image_out, int32(car4));
    image_out = step(all_lane, image_out, int32(count_car));

    

   
    %%{
    step(hVideoOrig, image);          % Original video
    step(hVideoFg,   fg_image);       % Foreground

    step(hVideosh,   fg_image2);
    step(hVideoFgd,   fg_bw_dil);
    step(hVideoFgf,  ch );
    step(hVideoRes,  image_out);     

    end


release(hvfr);
release(hvfw);
release(hvfw2);
release(hvfw3);
release(hvfw4);
% Close the video file
%release(hbfr);