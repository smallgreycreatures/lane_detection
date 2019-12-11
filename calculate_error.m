function [each_img_error_left, each_img_error_right, average_error_left, averrage_error_right] = calculate_error(estimated_left, estimated_right, ground_left, ground_rigt)


each_img_error_left = sqrt((estimate_left - ground_left).^2);
each_img_error_right = sqrt((estimated_right - ground_right).^2);

average_error_left = sum(each_img_error_left, 2)./size(each_img_error_left, 2);
averrage_error_right = sum(each_img_error_right, 2)./size(each_img_error_right, 2);

end