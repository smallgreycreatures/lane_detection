function [each_img_error_left, each_img_error_right, average_error_left, average_error_right] = calculate_error(estimated_left, estimated_right, ground_left, ground_right)


each_img_error_left = sqrt((estimated_left - ground_left).^2);
each_img_error_right = sqrt((estimated_right - ground_right).^2);


average_error_left_pixel = sum(each_img_error_left(1,:), 2)./size(each_img_error_left, 2)

average_error_left_angle = sum(rad2deg(each_img_error_left(2,:)), 2)./size(each_img_error_left, 2)

average_error_right_pixel = sum(each_img_error_right(1,:), 2)./size(each_img_error_right, 2)
average_error_right_angle = sum(rad2deg(each_img_error_right(2,:)), 2)./size(each_img_error_right, 2)
figure
subplot(2,1,1)
t = [0:1/30:size(estimated_left,2)/30-1/30];
plot(t,each_img_error_left(1,:))
title(sprintf('Squared error for left lane in pixels. MSE=%f pixels',average_error_left_pixel))
xlabel("time [s]")
ylabel("pixels")
subplot(2,1,2)

plot(t,rad2deg(each_img_error_left(2,:)))
title(sprintf('Squared error for left lane angle in degrees. MSE=%f deg',average_error_left_angle))
xlabel("time [s]")
ylabel("angle [deg]")
figure
subplot(2,1,1);
plot(t,each_img_error_right(1,:))
title(sprintf('Squared error for right lane in pixels. MSE=%f pixels',average_error_right_pixel ))
xlabel("time [s]")
ylabel("pixels")
subplot(2,1,2)
plot(t,rad2deg(each_img_error_right(2,:)))
title(sprintf('Squared error for right lane angle in degrees. MSE=%f deg', average_error_right_angle))
xlabel("time [s]")
ylabel("angle [deg]")



end