function fig = draw_line2(imge,line1, line2, colour1, colour2)
%figure(1)
fig = figure('visible', 'off');
imshow(imge);% h = gca; h.Visible = 'On'; hold on;

for i = 1:size(line1,1)
    x1 = line1(i,1);
    y1 = line1(i,2);
    x2 = line1(i,3);
    y2 = line1(i,4);
    
    line([x1,x2], [y1,y2], 'Color', colour1);
end

for i = 1:size(line2,1)
    x1 = line2(i,1);
    y1 = line2(i,2);
    x2 = line2(i,3);
    y2 = line2(i,4);
    
    line([x1,x2], [y1,y2], 'Color', colour2);
end
 
 