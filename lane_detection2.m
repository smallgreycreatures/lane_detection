%improve image processing to extraxt the white lines
%avg_time=1.1676
% times 1.6706    1.0914    1.0960    1.1067    1.2154    1.1561    1.1388    1.1028    1.0591    1.0389
close all;
clear all;

plot_it = 0;
calculate_error = 0;
t_max = 10;
times = [];

Is = [];
for k = 70:89
    matFilename = sprintf('images/mono_00000002%d.png', k);
    I = imread(matFilename);
    %imshow(a)
    Is = [Is; I];
end

left_gt = calculate_left_ground_truth();
right_gt = right_lane_ground_truth();

left_sigma = [];

prediction_error_tolerance = 50; %pixels
left_mu_est = [];
right_mu_est = [];
left_sigma_est = [];
right_sigma_est = [];
left_lane = [];
right_lane = [];
left_mu_est_list = [];
right_mu_est_list =[];
left_mu_list = [];
right_mu_list = [];

%defining region of interest �NDRA
top_margin = size(I,1)*0.55;
bottom_margin = size(I,1)*0.85;
left_lane_left_margin = 1;
left_lane_right_margin = size(I,2)*0.5;
right_lane_left_margin = size(I,2)*0.5;
right_lane_right_margin = size(I,2);
height = size(I,1);

for t = 1:t_max
tic

for i = 1:size(Is,1)/height 
    I = Is((i-1)*height+1:i*height,:);

%load test image
    left_lane_img = I(top_margin:bottom_margin,left_lane_left_margin:left_lane_right_margin);
    right_lane_img = I(top_margin:bottom_margin,right_lane_left_margin:right_lane_right_margin);

    left_processed_image = image_processing(left_lane_img);
    right_processed_image = image_processing(right_lane_img);
        
    left_lines = line_detect(left_processed_image,0.5,20,70);
    left_lane = decide_left_or_right_lane("left",left_lines,size(I,1),top_margin, left_lane_left_margin, left_lane_right_margin );
    if plot_it
        all_lines_drawn_left = draw_line(left_lane_img,left_lines, 'red');
        best_line_drawn_left = draw_line(I,left_lane,'red');

    end
        
    if ~isempty(left_lane)
        left_mu_list = [left_mu_list, [left_lane(6);left_lane(5)]];
    else
        left_mu_list = [left_mu_list, left_mu_list(:,size(left_mu_list,2))];
    end

    
    
    
    right_lines = line_detect(right_processed_image,0.5,-70,-20);
    right_lane = decide_left_or_right_lane("right",right_lines,size(I,1), top_margin, right_lane_left_margin, right_lane_right_margin );
    if plot_it
        all_lines_drawn_right = draw_line(right_lane_img,right_lines, 'green');
        best_line_drawn_right = draw_line(I,right_lane, 'green');
    end

    if ~isempty(right_lane)
        right_mu_list = [right_mu_list, [right_lane(6);right_lane(5)]];
    else
        right_mu_list = [right_mu_list, right_mu_list(:,size(right_mu_list,2))];
    end
    if plot_it
        both_lines_drawn = draw_line2(I,left_lines, right_lines, 'green', 'red');
        both_line_drawn = draw_line2(I,left_lane, right_lane, 'green', 'red');
    end
       
            
    if plot_it
        saveas(best_line_drawn_left, sprintf('lane_detect_2/left_line_2/%d.jpg', i), 'jpg');
        saveas(all_lines_drawn_left, sprintf('lane_detect_2/left_lines_2/%d.jpg', i), 'jpg');
        saveas(best_line_drawn_right, sprintf('lane_detect_2/right_line_2/%d.jpg', i), 'jpg');
        saveas(all_lines_drawn_right, sprintf('lane_detect_2/right_lines_2/%d.jpg', i), 'jpg');


        saveas(both_line_drawn, sprintf('lane_detect_2/both_line_2/%d.jpg', i), 'jpg');
        saveas(both_lines_drawn, sprintf('lane_detect_2/both_lines_2/%d.jpg', i), 'jpg');
    end
    
end

if calculate_error
    %calculate_error(left_mu_est_list(1:2,:), right_mu_est_list(1:2,:),left_gt(:,1:size(right_mu_est_list,2)),right_gt(:,1:size(right_mu_est_list,2)));
    calculate_error(left_mu_list(1:2,:), right_mu_list(1:2,:),left_gt(:,1:size(right_mu_list,2)),right_gt(:,1:size(right_mu_list,2)));
end

times = [times,toc]
end

averagetime = sum(times)/t_max