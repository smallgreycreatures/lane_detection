function processed_image = image_processing(I)
%IMAGE_PROCESSING Summary of this function goes here
%   Detailed explanation goes here
I = imgaussfilt(I,2);

for i = 1:size(I,1)
    for j = 1:size(I,2)
        if I(i,j) < 120
            I(i,j) = 0;
        else
            I(i,j) = 255;
        end
    end
end

% figure()
% imshow(I)
% title("white highlight")

processed_image = edge(I,'canny');

end

