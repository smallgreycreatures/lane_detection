%improve image processing to extraxt the white lines
close all;
clear all;

imgs = [];
for k = 70:89
    matFilename = sprintf('images/mono_00000002%d.png', k);
    img = imread(matFilename);
    H = size(img,1);
    %imshow(a)
    imgs = [imgs; img];
end
tic

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
for i = 1:size(imgs,1)/H 
    I = imgs((i-1)*H+1:i*H,:);
    %imshow(I)
   % I = imread('images/mono_0000000270.png');
    %imshow(I)
    %figure;
    %BW = edge(I,'canny');
    %imshow(BW)
    %figure;
    %[H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89);
    %imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
     %     'InitialMagnification','fit');



    %defining region of interest ÄNDRA
    top_margin = size(I,1)*0.55;%400/768;%pixels
    bottom_margin = size(I,1)*0.85;%680/768;%pixels
    left_lane_left_margin = 1;%size(I,2)*50/1024;
    left_lane_right_margin = size(I,2)*0.5;%525/1024;
    right_lane_left_margin = size(I,2)*0.5;%525/1024;
    right_lane_right_margin = size(I,2);%*1000/1024;
    height = size(I,1);

    %load test image
    left_lane_img = I(top_margin:bottom_margin,left_lane_left_margin:left_lane_right_margin);
    right_lane_img = I(top_margin:bottom_margin,right_lane_left_margin:right_lane_right_margin);
    %right_lane_img = flipdim(left_lane_img ,2); 
%     figure
%     imshow(left_lane_img)
%     figure
%     imshow(right_lane_img)
    


        left_processed_image = image_processing(left_lane_img);
        right_processed_image = image_processing(right_lane_img);
        
            %left_lines = detect_best_lines(left_ROI,170,90,75,105);
            left_lines = line_detect(left_processed_image,0.5,20,70);
%             all_lines_drawn_left = draw_line(left_lane_img,left_lines, 'red');
            left_lane = decide_left_or_right_lane("left",left_lines,size(I,1),top_margin, left_lane_left_margin, left_lane_right_margin );
%             best_line_drawn_left = draw_line(I,left_lane,'red');
            if ~isempty(left_lane)
                left_mu_list = [left_mu_list, [left_lane(6);left_lane(5)]];
            else
                left_mu_list = [left_mu_list, left_mu_list(:,size(left_mu_list,2))];
            end
        
            %right_lines = detect_best_lines(right_ROI,170,90,75,105);
            right_lines = line_detect(right_processed_image,0.5,-70,-20);
%             all_lines_drawn_right = draw_line(right_lane_img,right_lines, 'green');
            right_lane = decide_left_or_right_lane("right",right_lines,size(I,1), top_margin, right_lane_left_margin, right_lane_right_margin );
%             best_line_drawn_right = draw_line(I,right_lane, 'green');
            
            if ~isempty(right_lane)
                right_mu_list = [right_mu_list, [right_lane(6);right_lane(5)]];
            else
                right_mu_list = [right_mu_list, right_mu_list(:,size(right_mu_list,2))];
            end
            %both_lines_drawn = draw_line2(I,left_lines, right_lines, 'green', 'red');
%             both_line_drawn = draw_line2(I,left_lane, right_lane, 'green', 'red');

       
    %saveas(best_line_drawn_left, sprintf('left_line/%d.jpg', i), 'jpg');
    %saveas(all_lines_drawn_left, sprintf('left_lines/%d.jpg', i), 'jpg');
    %saveas(best_line_drawn_right, sprintf('right_line/%d.jpg', i), 'jpg');
    %saveas(all_lines_drawn_right, sprintf('right_lines/%d.jpg', i), 'jpg');
    
    
    %saveas(both_line_drawn, sprintf('both_line/%d.jpg', i), 'jpg');
    %saveas(both_lines_drawn, sprintf('both_lines/%d.jpg', i), 'jpg');

    
    %imwrite(left_processed_image, fullfile('left_ROI',sprintf('%d.jpg', i)));
    %imwrite(right_processed_image, fullfile('right_ROI',sprintf('%d.jpg', i)));
    
end
left_gt = calculate_left_ground_truth();
right_gt = right_lane_ground_truth();
%calculate_error(left_mu_est_list(1:2,:), right_mu_est_list(1:2,:),left_gt(:,1:size(right_mu_est_list,2)),right_gt(:,1:size(right_mu_est_list,2)));
calculate_error(left_mu_list(1:2,:), right_mu_list(1:2,:),left_gt(:,1:size(right_mu_list,2)),right_gt(:,1:size(right_mu_list,2)));

"BOTTOM"

toc