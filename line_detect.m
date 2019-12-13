function req_lines = line_detect(img, threshold, lower_angle_lim, upper_angle_lim)

%I = img;
%BW = edge(I,'canny');
[H,T,R] = hough(img);
P  = houghpeaks(H,10,'threshold',ceil(threshold*max(H(:))));

lines = houghlines(img,T,R,P);
thetas = [];
req_lines = [];
for i = 1:size(lines,2)
    theta = deg2rad(lines(i).theta);
    rho = lines(i).rho;
    p1 = lines(i).point1;
    x1 = p1(1);
    y1 = p1(2);
    p2 = lines(i).point2;
    x2 = p2(1);
    y2 = p2(2);
    if ~ismember(theta, thetas);
        thetas = [thetas, theta];
        angle = -(atan2(y2-y1, x2-x1) * 180 / pi);
        if angle > lower_angle_lim && angle < upper_angle_lim
            req_lines = [req_lines; [x1,y1,x2,y2,rho,theta]];
        end
    end
    
end


end
