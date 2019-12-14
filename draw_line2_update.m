function fig = draw_line2_update(imge, left_mu, right_mu, colour1, colour2)
%figure(1)
fig = figure('visible', 'off');
imshow(imge);% h = gca; h.Visible = 'On'; hold on;

height = size(image, 1);
theta = left_mu(2);
x1 = left_mu(1);
y1 = height;
x2 = 0;
y2 = height+(x1/tan(theta));
line([x1,x2], [y1,y2], 'Color', colour1, 'LineWidth', 1.5);

theta = right_mu(2);
x1 = right_mu(1);
y1 = height;
x2 = 0;
y2 = height+(x1/tan(theta));
line([x1,x2], [y1,y2], 'Color', colour2, 'LineWidth', 1.5);
 
 