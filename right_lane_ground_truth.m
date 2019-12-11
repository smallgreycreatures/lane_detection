function gt = right_lane_ground_truth()
x = 2*[641,581,585,589,596,602,607,610,567,572];
theta = deg2rad(-[134.8, 125.7, 126.1, 126.7, 127.4, 128.1, 128.5, 129,122.5,123.5] +90);
gt = [x;theta];

%{
%mono_0000000270:
alpha=134.8; 
x=641;
theta = degtorad(-alpha+90);
%mono_0000000271: 
alpha=125.7; 
x=581;
%mono_0000000272: 
alpha=126.1; 
x=585;
%mono_0000000273: 
alpha=126.7; 
x=589;
%mono_0000000274: 
alpha=127.4;
x=596
%mono_0000000275: 
alpha=128.1 
x=602
%mono_0000000276: 
alpha=128.5 
x=607
%mono_0000000277: 
alpha=129.0 
x=610
%mono_0000000278: 
alpha=122.5 
x=567
%mono_0000000279 
alpha=123.2 
x=572
%}
end