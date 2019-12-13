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
    
    %Kalman filter constants
    dt = 1.0;
    u = [0;0];
    acc_noise = 0.02;
    x1_measurement_noise = 0.1;
    theta_measurement_noise = 0.1;
    Q = [x1_measurement_noise,0;0,theta_measurement_noise]; %measurement prediction error
    R = acc_noise*[1,0,1,0; 0, 1,0,1;1,0,1,0; 0, 1,0,1]; % state prediction error

    %state and measurement equations
    A = [1,0,dt,0; 0,1,0,dt; 0,0,1,0; 0,0,0,1];
    B = [0,0;0,0;0,0;0,0];
    C = [1,0,0,0; 0,1,0,0];



    if ~isempty(left_lane)
        [left_mu_est,left_sigma_est] = kalman_filter_predict(A,B,u,R,left_mu,left_sigma);
        left_mu_est_list = [left_mu_est_list,left_mu_est];
    end
    if ~isempty(right_lane)
        [right_mu_est, right_sigma_est] = kalman_filter_predict(A,B,u,R,right_mu,right_sigma);
        right_mu_est_list = [right_mu_est_list,right_mu_est]; 
    end

    loop = 1;
    right_lane = [];
    left_lane = [];
    %find the lanes
    while (isempty(right_lane) || isempty(left_lane))
        left_processed_image = image_processing(left_lane_img);
        right_processed_image = image_processing(right_lane_img);
%         figure
%         imshow(left_processed_image)
%         figure
%         imshow(right_processed_image)
        
        %Elimination of Background based on Kalman Filtering
        if ~isempty(left_mu_est) && loop == 1
            left_processed_image = extract_ROI(left_processed_image,size(left_processed_image,2),size(left_processed_image,1),top_margin,left_lane_left_margin,height,left_mu_est,prediction_error_tolerance,'left');
            %figure
            %imshow(left_processed_image)
            %title("left processed image")
        end
        if ~isempty(right_mu_est) && loop == 1
            right_processed_image = extract_ROI(right_processed_image,size(right_processed_image,2),size(right_processed_image,1),top_margin,right_lane_left_margin,height,right_mu_est,prediction_error_tolerance,'right');
            %figure
            %imshow(right_processed_image)
            %title("right processed image")
        end

		

        
        if isempty(left_lane)
            %left_lines = detect_best_lines(left_ROI,170,90,75,105);
            left_lines = line_detect(left_processed_image,0.5,20,70);
            all_lines_drawn_left = draw_line(left_lane_img,left_lines, 'red');
            left_lane = decide_left_or_right_lane("left",left_lines,size(I,1),top_margin, left_lane_left_margin, left_lane_right_margin );
            best_line_drawn_left = draw_line(I,left_lane,'red');
            
        end
        if isempty(right_lane)
            %right_lines = detect_best_lines(right_ROI,170,90,75,105);
            right_lines = line_detect(right_processed_image,0.5,-70,-20);
            all_lines_drawn_right = draw_line(right_lane_img,right_lines, 'green');
            right_lane = decide_left_or_right_lane("right",right_lines,size(I,1), top_margin, right_lane_left_margin, right_lane_right_margin );
            best_line_drawn_right = draw_line(I,right_lane, 'green');
             
            %both_lines_drawn = draw_line2(I,left_lines, right_lines, 'green', 'red');
            both_line_drawn = draw_line2(I,left_lane, right_lane, 'green', 'red');

        end

        if ~isempty(left_lane)

            [left_mu,left_sigma] = kalman_filter_update(C,Q,R,left_mu_est, left_sigma_est, [left_lane(6);left_lane(5)] );
        end
        if ~isempty(right_lane)

            [right_mu,right_sigma] = kalman_filter_update(C,Q,R,right_mu_est, right_sigma_est, [right_lane(6);right_lane(5)]);
        end

                    if(loop >2)
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
                    end
                loop=loop+1;
    end
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
calculate_error(left_mu_est_list(1:2,:), right_mu_est_list(1:2,:),left_gt(:,1:size(right_mu_est_list,2)),right_gt(:,1:size(right_mu_est_list,2)));

"BOTTOM"
