function imge = draw_line(imge,draw_lines,colour)
figure()
imshow(imge);% h = gca; h.Visible = 'On'; hold on;

for i = 1:size(draw_lines,1)
    x1 = draw_lines(i,1);
    y1 = draw_lines(i,2);
    x2 = draw_lines(i,3);
    y2 = draw_lines(i,4);
    
    line([x1,x2], [y1,y2], 'Color', colour);
    %line([x1,x2], [y1,y2], 'Color', [0,0.15*i,0]);
end