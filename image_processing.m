function processed_image = image_processing(I)
%IMAGE_PROCESSING Summary of this function goes here
%   Detailed explanation goes here
I = imgaussfilt(I,2);
processed_image = edge(I,'canny');

end

