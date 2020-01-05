function img = extract_ROI(img,img_width,img_height,top_margin,left_margin, height, mu_est,prediction_error_tolerance,lane)
s0 
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


