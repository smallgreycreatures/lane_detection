function lista = calculate_left_ground_truth()

bs = [133, 131, 147, 147,147, 145, 139, 140, 143, 147];
vs = [33.2, 32.7, 32, 32, 32, 32.1, 32.5, 32.8, 32.1, 32];

ds = [];
for i = 1:length(bs);
    b = bs(i);
    d = -b*1600/1024;
    ds = [ds, d];
end

thetas = [];
for i = 1:length(vs);
    v = vs(i);
    theta = deg2rad(90 - v);
    thetas = [thetas, theta];
end

lista = [ds;thetas];
end