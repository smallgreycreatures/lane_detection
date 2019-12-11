function fig = draw_line(imge,draw_lines,colour)
%figure(1)
fig = figure('visible', 'off');
imshow(imge);% h = gca; h.Visible = 'On'; hold on;
%hold on;

for i = 1:size(draw_lines,1)
    x1 = draw_lines(i,1);
    y1 = draw_lines(i,2);
    x2 = draw_lines(i,3);
    y2 = draw_lines(i,4);
    
    line([x1,x2], [y1,y2], 'Color', colour);
    
    %figure()
    %line([x1,x2], [y1,y2], 'Color', colour);
end