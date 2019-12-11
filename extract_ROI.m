function img = extract_ROI(img,img_width,img_height,top_margin,left_margin, height, mu_est,prediction_error_tolerance,lane)
%{	
    extracts a strip with width of the prediction error tolerance included
    the line
	input:  lane - string, right or left lane
		img - the image
		img_width - int,
		img_height - int,
		top_margin, left_margin - ints, top and left margins used to obtain the current image from the original image based on which intercepts are calculated
		height - int, height of the original image based on which intercepts are calculated 
		mu_est - state estimate
		prediction_error_tolerance - int, the tolerance in pixels afforded to the estimated state
	output: img - image with everything blacked out except ROI
	%}
    theta = mu_est(2,1);
    x1 = mu_est(1,1);
    y1 = height;
    x2 = 0;
    y2 = height+(x1/tan(theta));
	if (lane == "left")
        %draw_line(img,[x1,y1,x2,y2],'green');
		for x =1:img_width
			for y = 1:img_height
				if y< (y1  -  top_margin - (((x+left_margin) - (x1))*(y1-y2) /(x2-x1))) - prediction_error_tolerance || y>(y1  -  top_margin - (((x+left_margin) - (x1))*(y1-y2) /(x2-x1))) + prediction_error_tolerance
					img(y,x) = 0;
                end
            end
        end
    end
    
    if (lane == "right")
        %draw_line(img,[x1,y1,x2,y2],'red');
		for x =1:img_width
			for y = 1:img_height
				if y<(y1  -  top_margin - (((x+left_margin) - (x1))*(y1-y2) /(x2-x1))) - prediction_error_tolerance ||  y>(y1  -  top_margin - (((x+left_margin) - (x1))*(y1-y2) /(x2-x1))) + prediction_error_tolerance
					img(y,x) = 0;
                end
            end
        end
    end
	
end


