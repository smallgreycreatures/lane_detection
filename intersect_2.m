function intersect = intersect_2(x1,y1,x2,y2,height,top_margin, left_margin)
%{
%find the intersect between the bottom of the image and the line.
%}  
    
	Y1 = -(y1+top_margin);
	X1 = x1+left_margin;
	Y2 = -(y2+top_margin);
	X2 = x2+left_margin;
	H = - height;
	k = (Y2-Y1)/(X2-X1);
    m = Y1-k*X1;
    
	intersect = 0;
	if k ~= 0
		intersect= (H-m)/k;
    end
end

