function lane = decide_left_or_right_lane(left_or_right,lines,height, top_margin, left_margin, right_margin )

	dist_weight = 2;  	
	angle_weight = 10;
	lane_score = -100000000;
	lane =[];
	
	if left_or_right == 'left'
		for i = 1:size(lines,1)
            x1 = lines(i, 1);
            y1 = lines(i, 2);
            x2 = lines(i, 3);
            y2 = lines(i, 4);
            rho = lines(i, 5);
            theta = lines(i, 6);
			intersection = intersect_2(x1,y1,x2,y2,height, top_margin,left_margin);
            
			if theta>0 && theta<pi/2 %the angle of left lane is assumed to be between 0and 90 degrees
				score = (-1*angle_weight*theta)+ (-1*dist_weight * (right_margin - intersection)); %lower the distance from center of the two lanes, higher the score, steeper the line higher the score
				if score > lane_score %the line with highest score is the left lane
					lane_score = score;
					lane = [x1+left_margin,y1+top_margin,x2+left_margin,y2+top_margin,theta,intersection];
                end
            end
        end
    end

	if left_or_right == 'right'
        for i = 1:size(lines,1)
            x1 = lines(i, 1);
            y1 = lines(i, 2);
            x2 = lines(i, 3);
            y2 = lines(i, 4);
            rho = lines(i, 5);
            theta = lines(i, 6);
			intersection = intersect_2(x1,y1,x2,y2,height,top_margin,left_margin);
			if theta < 0 && theta > -pi/2 %the angle of right lane is assumed to be between 180 and 90 degrees
				score = (angle_weight*theta)+ (-1*dist_weight * (intersection - left_margin)); %lower the distance from center of two lanes, higher the score, steeper the line higher the score
				if score > lane_score %the line with highest score is the right lane
					lane_score = score;
					lane = [x1+left_margin,y1+top_margin,x2+left_margin,y2+top_margin,theta,intersection];
                end
            end
        end
    end
    
end

