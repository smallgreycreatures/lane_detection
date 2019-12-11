function req_lines = line_detect(img, threshold, lower_angle_lim, upper_angle_lim)

%I = img;
%BW = edge(I,'canny');
[H,T,R] = hough(img);%,'Theta',[-90:89]);
P  = houghpeaks(H,10,'threshold',ceil(threshold*max(H(:))));


% req_lines = [];
% for i = 1:size(P,1)%each_line in all_lines:
% %     theta = P(i,2);
% %     if theta >= 90
% %         theta = theta - 180;
% %     else theta <= -90
% %         theta = theta + 180
%     theta = P(i,2)-90
%     theta = deg2rad(P(i,2)-90);
%     rho = P(i,1);
% 
%     %if theta < pi*lower_angle_lim/180 || theta > pi*upper_angle_lim/180
%         a = cos(theta);
%         b = sin(theta);
% 
%         x0 = a*rho;
%         y0 = b*rho;
%         x1 = round(x0 + 1000*(-b));
%         y1 = round(y0 + 1000*(a));
%         x2 = round(x0 - 1000*(-b));
%         y2 = round(y0 - 1000*(a));
% 
%         req_lines = [req_lines; [x1,y1,x2,y2,rho,theta]];
%     %end
% end






lines = houghlines(img,T,R,P);%,'FillGap',60,'MinLength',20);%'FillGap',60,'MinLength',250);
thetas = [];
req_lines = [];
for i = 1:size(lines,2)
    theta = deg2rad(lines(i).theta);%pi - deg2rad(lines(i).theta + 90);
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
            %approved = angle
            req_lines = [req_lines; [x1,y1,x2,y2,rho,theta]];
        end
    end
    
end



% 
% figure(), imshow(I), hold on
% max_len = 0;
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
% end




end