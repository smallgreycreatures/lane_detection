%improve image processing to extraxt the white lines
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

%defining region of interest ÄNDRA
top_margin = size(I,1)*0.55;
bottom_margin = size(I,1)*0.85;
left_lane_left_margin = 1;
left_lane_right_margin = size(I,2)*0.5;
right_lane_left_margin = size(I,2)*0.5;
right_lane_right_margin = size(I,2);
height = size(I,1);

left_gt = calculate_left_ground_truth();
right_gt = right_lane_ground_truth();

left_sigma = [];
prediction_error_tolerance = 50; %pixels
left_mu_est = [];
right_mu_est = [];
left_sigma_est = [];
right_sigma_est = [];
right_mu_list = [];
left_mu_list = [];
left_mu_est_list = [];
right_mu_est_list =[];

%Kalman filter constants
dt = 0.92;
u = [0;0];
acc_noise = 0.002;
x1_measurement_noise = 0.1;
theta_measurement_noise = 0.09;
Q = [x1_measurement_noise,0;0,theta_measurement_noise]; %measurement prediction error
R = acc_noise*[1,0,1,0; 0, 1,0,1;1,0,1,0; 0, 1,0,1]; % state prediction error

%state and measurement equations
A = [1,0,dt,0; 0,1,0,dt; 0,0,1,0; 0,0,0,1];
B = [0,0;0,0;0,0;0,0];
C = [1,0,0,0; 0,1,0,0];



for t = 1:t_max
    
%the algorithm starts now!!!!
tic

%load the first image
    i = 1;
    I = Is((i-1)*height+1:i*height,:);

%crop the image
    left_lane_image = I(top_margin:bottom_margin,left_lane_left_margin:left_lane_right_margin);
    right_lane_image = I(top_margin:bottom_margin,right_lane_left_margin:right_lane_right_margin);

%process the image
    left_processed_image = image_processing(left_lane_image);
    right_processed_image = image_processing(right_lane_image);
    
% the ROI (in first iteration no ROI)
    left_processed_image_ROI = left_processed_image;
    right_processed_image_ROI = right_processed_image;
    if plot_it == 1
        left_lane_image_ROI = left_lane_image;
        right_lane_image_ROI = right_lane_image;
    end

%get the lines
    left_lines = line_detect(left_processed_image,0.5,20,70);
    left_lane = decide_left_or_right_lane("left",left_lines,size(I,1),top_margin, left_lane_left_margin, left_lane_right_margin );
    if plot_it == 1
        fig_all_found_lines_left = draw_line(left_lane_image,left_lines, 'red');
        fig_best_line_left = draw_line(I,left_lane,'red');         
    end
    
    right_lines = line_detect(right_processed_image,0.5,-70,-20);
    right_lane = decide_left_or_right_lane("right",right_lines,size(I,1), top_margin, right_lane_left_margin, right_lane_right_margin );
    if plot_it == 1
        fig_all_found_lines_right = draw_line(right_lane_image,right_lines, 'green');
        fig_best_line_right = draw_line(I,right_lane, 'green');
    end
    
    if plot_it == 1
        fig_both_best_lines = draw_line2(I,left_lane, right_lane, 'green', 'red');
    end
    
%kalman update, creats estimate from first measurment values
    [left_mu,left_sigma] = kalman_filter_update(C,Q,R,left_mu_est, left_sigma_est, [left_lane(6);left_lane(5)] );
    left_mu_list = [left_mu_list, left_mu];
    
    [right_mu,right_sigma] = kalman_filter_update(C,Q,R,right_mu_est, right_sigma_est, [right_lane(6);right_lane(5)]);
    right_mu_list = [right_mu_list, right_mu];
    
    if plot_it == 1
        fig_both_lines_updated = draw_line2_update(I, left_mu, right_mu, 'red', 'green');
    end
    
%save images
    if plot_it == 1
        imwrite(left_lane_image, fullfile('left_image',sprintf('%d.jpg', i)));
        imwrite(right_lane_image, fullfile('right_image',sprintf('%d.jpg', i)));
        imwrite(left_processed_image, fullfile('left_processed',sprintf('%d.jpg', i)));
        imwrite(right_processed_image, fullfile('right_processed',sprintf('%d.jpg', i)));
        imwrite(left_processed_image_ROI, fullfile('left_processed_ROI',sprintf('%d.jpg', i)));
        imwrite(right_processed_image_ROI, fullfile('right_processed_ROI',sprintf('%d.jpg', i)));
        imwrite(left_lane_image_ROI, fullfile('left_image_ROI',sprintf('%d.jpg', i)));
        imwrite(right_lane_image_ROI, fullfile('right_image_ROI',sprintf('%d.jpg', i)));

        saveas(fig_all_found_lines_left, sprintf('left_lines/%d.jpg', i), 'jpg');
        saveas(fig_best_line_left, sprintf('left_line/%d.jpg', i), 'jpg');
        saveas(fig_all_found_lines_right, sprintf('right_lines/%d.jpg', i), 'jpg');
        saveas(fig_best_line_right, sprintf('right_line/%d.jpg', i), 'jpg');

        saveas(fig_both_best_lines, sprintf('both_lines/%d.jpg', i), 'jpg');
        saveas(fig_both_lines_updated, sprintf('both_lines_updated/%d.jpg', i), 'jpg');
    end
    
    
for i = 2:size(Is,1)/height
  
%load test image
    I = Is((i-1)*height+1:i*height,:);
    %imshow(I)
    
%crop image
    left_lane_image = I(top_margin:bottom_margin,left_lane_left_margin:left_lane_right_margin);
    right_lane_image = I(top_margin:bottom_margin,right_lane_left_margin:right_lane_right_margin);
    %figure
    %imshow(left_lane_img)
    %figure
    %imshow(right_lane_img)

%kalman predict
    [left_mu_est,left_sigma_est] = kalman_filter_predict(A,B,u,R,left_mu,left_sigma);
    left_mu_est_list = [left_mu_est_list,left_mu_est];

    [right_mu_est, right_sigma_est] = kalman_filter_predict(A,B,u,R,right_mu,right_sigma);
    right_mu_est_list = [right_mu_est_list,right_mu_est]; 

%find the lanes
    left_processed_image = image_processing(left_lane_image);
    right_processed_image = image_processing(right_lane_image);
    %figure
    %imshow(left_processed_image)
    %figure
    %imshow(right_processed_image)
        
%Elimination of Background based on Kalman Filtering
    left_processed_image_ROI = extract_ROI(left_processed_image,size(left_processed_image,2),size(left_processed_image,1),top_margin,left_lane_left_margin,height,left_mu_est,prediction_error_tolerance,'left');
    right_processed_image_ROI = extract_ROI(right_processed_image,size(right_processed_image,2),size(right_processed_image,1),top_margin,right_lane_left_margin,height,right_mu_est,prediction_error_tolerance,'right');
    
    if plot_it == 1
        left_lane_image_ROI = extract_ROI(left_lane_image,size(left_processed_image,2),size(left_processed_image,1),top_margin,left_lane_left_margin,height,left_mu_est,prediction_error_tolerance,'left');
        right_lane_image_ROI = extract_ROI(right_lane_image,size(right_processed_image,2),size(right_processed_image,1),top_margin,right_lane_left_margin,height,right_mu_est,prediction_error_tolerance,'right');
    end
    
%find lines and lanes
    left_lines = line_detect(left_processed_image_ROI,0.5,20,70);
    left_lane = decide_left_or_right_lane("left",left_lines,size(I,1),top_margin, left_lane_left_margin, left_lane_right_margin );
    if plot_it == 1
        fig_all_found_lines_left = draw_line(left_lane_image,left_lines, 'red');
        fig_best_line_left = draw_line(I,left_lane,'red');   
    end
    
    right_lines = line_detect(right_processed_image_ROI,0.5,-70,-20);
    right_lane = decide_left_or_right_lane("right",right_lines,size(I,1), top_margin, right_lane_left_margin, right_lane_right_margin );
    if plot_it == 1
        fig_all_found_lines_right = draw_line(right_lane_image,right_lines, 'green');
        fig_best_line_right = draw_line(I,right_lane, 'green');
    end
    
    if plot_it == 1
        fig_both_best_lines = draw_line2(I,left_lane, right_lane, 'green', 'red');
    end
    
 %if nesseary, creat line from predicted values
    if isempty(left_lane)
        x1 = left_mu_est(1,1);
        y1 = height;
        x2 = 0;
        y2 = height+(left_mu_est(1,1)/tan(left_mu_est(2,1)));
        theta = left_mu_est(2,1);
        intersect = left_mu_est(1,1);
        left_lane = [x1,y1,x2,y2,theta,intersect];
    end
    if isempty(right_lane)
        x1 = right_mu_est(1,1);
        y1 = height;
        x2 = 0;
        y2 = height+(right_mu_est(1,1)/tan(right_mu_est(2,1)));
        theta = right_mu_est(2,1);
        intersect = right_mu_est(1,1);
        right_lane = [x1,y1,x2,y2,theta,intersect];
    end

%Kalman update
    [left_mu,left_sigma] = kalman_filter_update(C,Q,R,left_mu_est, left_sigma_est, [left_lane(6);left_lane(5)] );
    left_mu_list = [left_mu_list, left_mu];

    [right_mu,right_sigma] = kalman_filter_update(C,Q,R,right_mu_est, right_sigma_est, [right_lane(6);right_lane(5)]);
    right_mu_list = [right_mu_list, right_mu];
    
    if plot_it == 1
        fig_both_lines_updated = draw_line2_update(I, left_mu, right_mu, 'red', 'green');
    end
    

%save everything
    if plot_it == 1
        imwrite(left_lane_image, fullfile('left_image',sprintf('%d.jpg', i)));
        imwrite(right_lane_image, fullfile('right_image',sprintf('%d.jpg', i)));
        imwrite(left_processed_image, fullfile('left_processed',sprintf('%d.jpg', i)));
        imwrite(right_processed_image, fullfile('right_processed',sprintf('%d.jpg', i)));
        imwrite(left_processed_image_ROI, fullfile('left_processed_ROI',sprintf('%d.jpg', i)));
        imwrite(right_processed_image_ROI, fullfile('right_processed_ROI',sprintf('%d.jpg', i)));
        imwrite(left_lane_image_ROI, fullfile('left_image_ROI',sprintf('%d.jpg', i)));
        imwrite(right_lane_image_ROI, fullfile('right_image_ROI',sprintf('%d.jpg', i)));

        saveas(fig_all_found_lines_left, sprintf('left_lines/%d.jpg', i), 'jpg');
        saveas(fig_best_line_left, sprintf('left_line/%d.jpg', i), 'jpg');
        saveas(fig_all_found_lines_right, sprintf('right_lines/%d.jpg', i), 'jpg');
        saveas(fig_best_line_right, sprintf('right_line/%d.jpg', i), 'jpg');

        saveas(fig_both_best_lines, sprintf('both_lines/%d.jpg', i), 'jpg');
        saveas(fig_both_lines_updated, sprintf('both_lines_updated/%d.jpg', i), 'jpg');
    end
    
end

if calculate_error
    %calculate_error(left_mu_est_list(1:2,:), right_mu_est_list(1:2,:),left_gt(:,1:size(right_mu_est_list,2)),right_gt(:,1:size(right_mu_est_list,2)));
    calculate_error(left_mu_list(1:2,:), right_mu_list(1:2,:),left_gt(:,1:size(right_mu_list,2)),right_gt(:,1:size(right_mu_list,2)));
end

times = [times, toc] 
end

average_time = sum(times)/t_max
